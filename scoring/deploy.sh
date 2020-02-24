#!/usr/bin/env bash
set -x

printf "\n\n######## frontend/deploy ########\n"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT=${PROJECT:-scoring}
QUAY_ORG=${QUAY_ORG:-redhatdemo}

oc project ${PROJECT} 2> /dev/null || oc new-project ${PROJECT}

echo "Deploying Scoring Service"

SCORING_SERVER_PARAMS="IMAGE_REPOSITORY=quay.io/${QUAY_ORG}/2020-scoring-server:latest -p REPLICAS=1"

oc process -f "${DIR}/scoring-server.yml" ${SCORING_SERVER_PARAMS} | oc create -f -

