#!/usr/bin/env bash

set -eu 

set -o pipefail

printf "\n\n######## leaderboard/deploy ########\n"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT=${PROJECT:-leaderboard}
QUAY_ORG=${QUAY_ORG:-redhatdemo}

oc apply \
  -f  "${DIR}/leaderboard-deploy-secret.yaml" \
  -f "${DIR}/leaderboard-pipeline-resources.yaml" \
  -f "${DIR}/leaderboard-deploy-pipeline.yaml"


oc process -f "${DIR}/leaderboard-aggregator.yaml" | oc create -f -
oc process -f "${DIR}/leaderboard-mock-producer.yaml" | oc create -f -



