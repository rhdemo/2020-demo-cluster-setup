#!/usr/bin/env bash

set -eu 

set -o pipefail

printf "\n\n######## leaderboard/deploy ########\n"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT=${LEADERBOARD_NAMESPACE:-leaderboard}
QUAY_ORG=${QUAY_ORG:-redhatdemo}

envsubst < "${DIR}/leaderboard-aggregato-secret.yaml" | oc create -n $PROJECT -f - 

oc apply -n $PROJECT \
  -f "${DIR}/leaderboard-pipeline-resources.yaml" \
  -f "${DIR}/leaderboard-deploy-pipeline.yaml"

# Patch Pipeline SA 
oc patch sa -n $PROJECT pipeline \
  --type='json' -p='[{"op": "add", "path": "/secrets/1", "value": {"name": "leaderboard-git" } },
  {"op": "add", "path": "/secrets/2", "value": {"name": "leaderboard-quay" } }]'

# Start leaderboard-mock-producer deployment
oc process -f "${DIR}/leaderboard-aggregator.yaml" | oc create -f -
tkn pipeline start leaderboard-deploy \
  --resource app-source=git-source \
  --resource app-image=leaderboard-mock-producer-image \
  --serviceaccount=pipeline \
  --param appName=leaderboard-mock-producer \
  --param applicationSrcDir=leaderboard-mock-producer \
  --param mavenMirrorUrl="$MAVEN_MIRROR_URL"

# Start leaderboard-mock-producer deployment
oc process -f "${DIR}/leaderboard-mock-producer.yaml" | oc create -f -
tkn pipeline start leaderboard-aggregator \
  --resource app-source=git-source \
  --resource app-image=leaderboard-aggregator-image \
  --serviceaccount=pipeline \
  --param appName=leaderboard-aggregator \
  --param applicationSrcDir=leaderboard-aggregator \
  --param mavenMirrorUrl="$MAVEN_MIRROR_URL"

