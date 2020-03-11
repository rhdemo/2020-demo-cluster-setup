#!/usr/bin/env bash

printf "\n\n######## frontend/deploy ########\n"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT=${PROJECT:-admin-hq}
QUAY_ORG=${QUAY_ORG:-redhatdemo}
KEY_FILE=${KEY_FILE:-prod-key.pem}
CERTIFICATE_FILE=${CERTIFICATE_FILE:-prod-cert.pem}
CA_FILE=${CA_FILE:-prod-ca.pem}
CLUSTER_NAME=${CLUSTER_NAME:-HQ}

oc project ${PROJECT} 2> /dev/null || oc new-project ${PROJECT}

echo "Deploying Admin HQ Applications"

oc process -f "${DIR}/admin-config.yml" -p CLUSTER_NAME=${CLUSTER_NAME} | oc create -f -

ADMIN_SERVER_PARAMS="-p REPLICAS=2"
oc process -f "${DIR}/admin-server.yml" ${ADMIN_SERVER_PARAMS} | oc create -f -

ADMIN_UI_PARAMS="-p REPLICAS=2"
oc process -f "${DIR}/admin-ui.yml" ${ADMIN_UI_PARAMS} | oc create -f -
