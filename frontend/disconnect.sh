#!/usr/bin/env bash

printf "\n\n######## disconnect from ha proxy ########\n"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT=${PROJECT:-frontend}

oc project ${PROJECT} 2> /dev/null || oc new-project ${PROJECT}


oc process -f "${DIR}/phone-route.yml" | oc delete -f -
oc rollout latest dc/phone-ui
oc rollout latest dc/phone-server
