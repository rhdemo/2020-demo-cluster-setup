#!/usr/bin/env bash

printf "\n\n######## frontend/deploy ########\n"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT=${PROJECT:-frontend}
QUAY_ORG=${QUAY_ORG:-redhatdemo}
KEY_FILE=${KEY_FILE:-prod-key.pem}
CERTIFICATE_FILE=${CERTIFICATE_FILE:-prod-cert.pem}
CA_FILE=${CA_FILE:-prod-ca.pem}
CLUSTER_NAME=${CLUSTER_NAME:-EDGE}

oc project ${PROJECT} 2> /dev/null || oc new-project ${PROJECT}

echo "Deploying Frontend Applications"
if [[ "${FRONTEND_MINI}" = "true" ]]; then
    echo "Deploying low resource installation."
fi

oc process -f "${DIR}/common.yml" -p CLUSTER_NAME=${CLUSTER_NAME} | oc create -f -

ADMIN_EDGE_PARAMS="-p REPLICAS=2"
oc process -f "${DIR}/admin-edge.yml" ${ADMIN_EDGE_PARAMS} | oc create -f -

PHONE_SERVER_PARAMS="-p REPLICAS=2"
oc process -f "${DIR}/phone-server.yml" ${PHONE_SERVER_PARAMS} | oc create -f -

PHONE_UI_PARAMS="-p REPLICAS=2"
oc process -f "${DIR}/phone-ui.yml" ${PHONE_UI_PARAMS} | oc create -f -

