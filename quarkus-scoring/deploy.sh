#!/usr/bin/env bash

printf "\n\n######## scoring/deploy ########\n"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT=${PROJECT:-scoring}
CLUSTER_NAME=${CLUSTER_NAME:-EDGE}

oc project ${PROJECT} 2> /dev/null || oc new-project ${PROJECT}
oc adm policy add-scc-to-user anyuid -n scoring -z default

echo "Deploying Scoring Service"

oc process -f "${DIR}/scoring-server.yml" -p CLUSTER_NAME="${CLUSTER_NAME}" | oc create -f -
