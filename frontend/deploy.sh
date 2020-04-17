#!/usr/bin/env bash

printf "\n\n######## frontend/deploy ########\n"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT=${PROJECT:-frontend}
KEY_FILE=${KEY_FILE:-prod-key.pem}
CERTIFICATE_FILE=${CERTIFICATE_FILE:-prod-cert.pem}
CA_FILE=${CA_FILE:-prod-ca.pem}
CLUSTER_NAME=${CLUSTER_NAME:-EDGE}
ROLLOUT_STRATEGY=${ROLLOUT_STRATEGY:-Rolling}

oc project ${PROJECT} 2> /dev/null || oc new-project ${PROJECT}

oc process -f "${DIR}/common.yml" -p CLUSTER_NAME="${CLUSTER_NAME}" | oc create -f -

echo "Deploying the Skupper Network"
##
## To install skupper locally:
##    curl -fL https://github.com/skupperproject/skupper-cli/releases/download/0.1.0/skupper-cli-0.1.0-linux-amd64.tgz | tar -xzf -
##
## This places the skupper executable in the current directory.  Move the executable to a location that is in the execution path.
##
SKUPPER_NAME="$(echo ${CLUSTER_NAME} | sed 's/ /_/g')"
skupper init --id "${SKUPPER_NAME}"

oc process -f "${DIR}/admin-edge.yml" | oc create -f -
oc process -f "${DIR}/bot-server.yml" | oc create -f -
oc process -f "${DIR}/phone-server.yml" -p ROLLOUT_STRATEGY="${ROLLOUT_STRATEGY}" | oc create -f -
oc process -f "${DIR}/phone-ui.yml" -p ROLLOUT_STRATEGY="${ROLLOUT_STRATEGY}" | oc create -f -
oc process -f "${DIR}/phone-route.yml"  | oc create -f -

skupper connect "${DIR}/../.secrets/hq.yml"
