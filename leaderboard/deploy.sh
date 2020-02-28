#!/usr/bin/env bash

set -eu 

set -o pipefail

printf "\n\n######## leaderboard/deploy ########\n"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT=${LEADERBOARD_NAMESPACE:-leaderboard}
QUAY_ORG=${QUAY_ORG:-redhatdemo}

! oc new-project $PROJECT 2>/dev/null

if [[ "${CREATE_DB}" = "true" ]]; then
  echo "Deploying PostgeSQL"
  POSTGRESQL_PARAMS="POSTGRESQL_USER=demo \
    -p POSTGRESQL_PASSWORD=password! \
    -p POSTGRESQL_DATABASE=gamedb"  
  oc process -n openshift postgresql-persistent $POSTGRESQL_PARAMS | oc apply -f -
  oc process -f  "${DIR}/db-adminer.yaml" | oc apply -f -
fi

envsubst < "${DIR}/leaderboard-deploy-secret.yaml" | oc create -n $PROJECT -f - 

# Patch tekton config-defaults  
oc patch -n openshift-pipelines cm config-defaults \
  --patch "$(cat ${DIR}/pod-template-patch.yaml)"

oc apply -n $PROJECT \
  -f "${DIR}/leaderboard-pipeline-resources.yaml" \
  -f "${DIR}/build-quarkus-app.yaml" \
  -f "${DIR}/leaderboard-deploy-pipeline.yaml"

# Patch Pipeline SA 
oc patch sa -n $PROJECT pipeline \
  --type='json' -p='[{"op": "add", "path": "/secrets/-", "value": {"name": "leaderboard-git" } },
  {"op": "add", "path": "/secrets/-", "value": {"name": "leaderboard-quay" } }]'

# Start leaderboard-mock-producer deployment
oc process -f "${DIR}/leaderboard-aggregator.yaml" | oc create -f -
tkn pipeline start leaderboard-deploy \
  --resource app-source=git-source \
  --resource app-image=leaderboard-aggregator-image \
  --param appName=leaderboard-aggregator \
  --param applicationSrcDir=leaderboard-aggregator \
  --param mavenMirrorUrl="$MAVEN_MIRROR_URL"

# Start leaderboard-mock-producer deployment
oc process -f "${DIR}/leaderboard-mock-producer.yaml" | oc create -f -
tkn pipeline start leaderboard-deploy \
  --resource app-source=git-source \
  --resource app-image=leaderboard-mock-producer-image \
  --param appName=leaderboard-mock-producer \
  --param applicationSrcDir=leaderboard-mock-producer \
  --param mavenMirrorUrl="$MAVEN_MIRROR_URL"