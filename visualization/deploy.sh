#!/usr/bin/env bash

printf "\n\n######## visualization/deploy ########\n"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT=${PROJECT:-leaderboard}
QUAY_ORG=${QUAY_ORG:-redhatdemo}

oc project ${PROJECT} 2> /dev/null || oc new-project ${PROJECT}
LEADERBOARD_UI_PARAMS=""
oc process -f "${DIR}/leaderboard-ui.yml" ${LEADERBOARD_UI_PARAMS} | oc create -f -
