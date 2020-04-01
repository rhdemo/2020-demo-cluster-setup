#!/usr/bin/env bash

printf "\n\n######## scoring/deploy ########\n"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT=${PROJECT:-frontend}
CLUSTER_NAME=${CLUSTER_NAME:-EDGE}

oc project ${PROJECT} 2> /dev/null || oc new-project ${PROJECT}

echo "Deploying Scoring Service"

oc process -f "${DIR}/scoring-server.yml" -p CLUSTER_NAME="${CLUSTER_NAME}" | oc create -f -

