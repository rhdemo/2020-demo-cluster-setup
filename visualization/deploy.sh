#!/usr/bin/env bash

printf "\n\n######## visualization/deploy ########\n"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT=${PROJECT:-visualization}
QUAY_ORG=${QUAY_ORG:-redhatdemo}

oc project ${PROJECT} 2> /dev/null || oc new-project ${PROJECT}

echo "Deploying Visualization Applications"
if [[ "${FRONTEND_MINI}" = "true" ]]; then
    echo "Deploying low resource installation."
fi

if [[ "${FRONTEND_MINI}" = "true" ]]; then
    DASHBOARD_UI_PARAMS="IMAGE_REPOSITORY=quay.io/${QUAY_ORG}/2020-dashboard-ui:latest \
    -p REPLICAS=1 \
    -p CONTAINER_REQUEST_CPU=100m \
    -p CONTAINER_REQUEST_MEMORY=100Mi"
else
    DASHBOARD_UI_PARAMS="-p REPLICAS=2"
fi
oc process -f "${DIR}/dashboard-ui.yml" ${DASHBOARD_UI_PARAMS} | oc create -f -

if [[ "${FRONTEND_MINI}" = "true" ]]; then
    LEADERBOARD_UI_PARAMS="IMAGE_REPOSITORY=quay.io/${QUAY_ORG}/2020-leaderboard-ui:latest \
    -p REPLICAS=1 \
    -p CONTAINER_REQUEST_CPU=100m \
    -p CONTAINER_REQUEST_MEMORY=100Mi"
else
    LEADERBOARD_UI_PARAMS="-p REPLICAS=2"
fi
oc process -f "${DIR}/leaderboard-ui.yml" ${LEADERBOARD_UI_PARAMS} | oc create -f -
