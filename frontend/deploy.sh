#!/usr/bin/env bash

printf "\n\n######## frontend/deploy ########\n"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT=${PROJECT:-frontend}
QUAY_ORG=${QUAY_ORG:-redhatdemo}
KEY_FILE=${KEY_FILE:-prod-key.pem}
CERTIFICATE_FILE=${CERTIFICATE_FILE:-prod-cert.pem}
CA_FILE=${CA_FILE:-prod-ca.pem}

oc project ${PROJECT} 2> /dev/null || oc new-project ${PROJECT}

echo "Deploying Frontend Application"
if [[ "${FRONTEND_MINI}" = "true" ]]; then
    echo "Deploying low resource installation."
fi

oc process -f "${DIR}/common.yml" \
  | oc create -f -

if [[ "${FRONTEND_MINI}" = "true" ]]; then
    ADMIN_SERVER_PARAMS="IMAGE_REPOSITORY=quay.io/${QUAY_ORG}/2020-admin-server:latest \
    -p REPLICAS=1 \
    -p CONTAINER_REQUEST_CPU=100m \
    -p CONTAINER_REQUEST_MEMORY=100Mi"
else
    ADMIN_SERVER_PARAMS="-p REPLICAS=2"
fi
oc process -f "${DIR}/admin-server.yml" ${ADMIN_SERVER_PARAMS} | oc create -f -


if [[ "${FRONTEND_MINI}" = "true" ]]; then
    ADMIN_UI_PARAMS="IMAGE_REPOSITORY=quay.io/${QUAY_ORG}/2020-admin-ui:latest \
    -p REPLICAS=1 \
    -p CONTAINER_REQUEST_CPU=100m \
    -p CONTAINER_REQUEST_MEMORY=100Mi"
else
    ADMIN_UI_PARAMS="-p REPLICAS=2"
fi
oc process -f "${DIR}/admin-ui.yml" ${ADMIN_UI_PARAMS} | oc create -f -

if [[ "${FRONTEND_MINI}" = "true" ]]; then
    PHONE_SERVER_PARAMS="IMAGE_REPOSITORY=quay.io/${QUAY_ORG}/2020-phone-server:latest \
    -p REPLICAS=1 \
    -p CONTAINER_REQUEST_CPU=100m \
    -p CONTAINER_REQUEST_MEMORY=100Mi"
else
    PHONE_SERVER_PARAMS="-p REPLICAS=2"
fi
oc process -f "${DIR}/phone-server.yml" ${PHONE_SERVER_PARAMS} | oc create -f -


if [[ "${FRONTEND_MINI}" = "true" ]]; then
    PHONE_UI_PARAMS="IMAGE_REPOSITORY=quay.io/${QUAY_ORG}/2020-phone-ui:latest \
    -p REPLICAS=1 \
    -p CONTAINER_REQUEST_CPU=100m \
    -p CONTAINER_REQUEST_MEMORY=100Mi"
else
    PHONE_UI_PARAMS="-p REPLICAS=2"
fi
oc process -f "${DIR}/phone-ui.yml" ${PHONE_UI_PARAMS} | oc create -f -


if [[ "${FRONTEND_MINI}" = "true" ]]; then
    DASHBOARD_SERVER_PARAMS="IMAGE_REPOSITORY=quay.io/${QUAY_ORG}/2020-dashboard-server:latest \
    -p REPLICAS=1 \
    -p CONTAINER_REQUEST_CPU=100m \
    -p CONTAINER_REQUEST_MEMORY=100Mi"
else
    DASHBOARD_SERVER_PARAMS="-p REPLICAS=2"
fi
oc process -f "${DIR}/dashboard-server.yml" ${DASHBOARD_SERVER_PARAMS} | oc create -f -


if [[ "${FRONTEND_MINI}" = "true" ]]; then
    DASHBOARD_UI_PARAMS="IMAGE_REPOSITORY=quay.io/${QUAY_ORG}/2020-dashboard-ui:latest \
    -p REPLICAS=1 \
    -p CONTAINER_REQUEST_CPU=100m \
    -p CONTAINER_REQUEST_MEMORY=100Mi"
else
    DASHBOARD_UI_PARAMS="-p REPLICAS=2"
fi
oc process -f "${DIR}/dashboard-ui.yml" ${DASHBOARD_UI_PARAMS} | oc create -f -

