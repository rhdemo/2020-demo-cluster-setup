#!/usr/bin/env bash
set -x

printf "\n\n######## scoring/deploy ########\n"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT=${PROJECT:-frontend}

oc project ${PROJECT}
oc process -f "${DIR}/scoring-server.yml" | oc delete -f -
