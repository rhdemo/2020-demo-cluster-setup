#!/usr/bin/env bash

printf "\n\n######## frontend/undeploy ########\n"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT=${PROJECT:-frontend}

oc project ${PROJECT}
oc process -f "${DIR}/common.yml" | oc delete -f -
oc process -f "${DIR}/admin-edge.yml"  | oc delete -f -
oc process -f "${DIR}/phone-server.yml" | oc delete -f -
oc process -f "${DIR}/phone-route.yml" | oc delete -f -
oc process -f "${DIR}/phone-ui.yml" | oc delete -f -

skupper delete
