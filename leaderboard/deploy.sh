#!/usr/bin/env bash

set -eu 

set -o pipefail

printf "\n\n######## leaderboard/deploy ########\n"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT=${LEADERBOARD_NAMESPACE:-leaderboard}
KAFKA_NAMESPACE=${KAFKA_NAMESPACE:-kafka-demo}
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

if [[ "${REDEPLOY}" = "false" ]]; then
  
  printf "\n\n######## leaderboard::deploy:: Create Leaderboard Topics ########\n"
  oc create -n $KAFKA_NAMESPACE -f "${DIR}/topics.yaml"

  printf "\n\n######## leaderboard::deploy:: Create Secrets ########\n"

  envsubst < "${DIR}/leaderboard-deploy-secret.yaml" \
    | oc create -n $PROJECT -f - 

  printf "\n\n######## leaderboard::deploy:: Patch PodTemplate ########\n"
  # Patch tekton config-defaults  
  oc patch -n openshift-pipelines cm config-defaults \
    --patch "$(cat ${DIR}/pod-template-patch.yaml)"

  printf "\n\n######## leaderboard::deploy:: Create Pipeline Resources ########\n"
  oc apply -n $PROJECT \
    -f "${DIR}/leaderboard-pipeline-resources.yaml" \
    -f "${DIR}/build-quarkus-app.yaml" \
    -f "${DIR}/leaderboard-deploy-pipeline.yaml"

  printf "\n\n######## leaderboard::deploy:: Patch 'pipeline' SA ########\n"
  # Patch Pipeline SA 
  oc patch sa -n $PROJECT pipeline \
    --type='json' -p='[{"op": "add", "path": "/secrets/-", "value": {"name": "leaderboard-git" } },
    {"op": "add", "path": "/secrets/-", "value": {"name": "leaderboard-quay" } }]'

  # Start leaderboard-mock-producer deployment
  printf "\n\n######## leaderboard::deploy:: Create Leaderboard Aggregator ########\n"
  oc process -f "${DIR}/leaderboard-aggregator.yaml" | oc create -f -
else
  printf "\n\n######## leaderboard::deploy:: Skip resource creation ########\n"
fi

printf "\n\n######## leaderboard::deploy:: Deploy Leaderboard Aggregator ########\n"
tkn pipeline start leaderboard-deploy \
  --param appName=leaderboard-aggregator \
  --resource app-source=git-source \
  --resource app-image=leaderboard-aggregator-image \
  --param appName=leaderboard-aggregator \
  --param applicationSrcDir=leaderboard-aggregator \
  --param mavenMirrorUrl="$MAVEN_MIRROR_URL" 