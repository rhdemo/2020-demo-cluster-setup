#!/usr/bin/env bash

printf "\n\n######## admin/undeploy ########\n"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT=${PROJECT:-admin-hq}

oc project ${PROJECT}
oc process -f "${DIR}/admin-config.yml" | oc delete -f -
oc process -f "${DIR}/admin-server.yml" | oc delete -f -
oc process -f "${DIR}/admin-ui.yml"  | oc delete -f -

skupper delete
