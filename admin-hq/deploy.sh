#!/usr/bin/env bash

printf "\n\n######## admin/deploy ########\n"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT=${PROJECT:-admin-hq}
QUAY_ORG=${QUAY_ORG:-redhatdemo}
KEY_FILE=${KEY_FILE:-prod-key.pem}
CERTIFICATE_FILE=${CERTIFICATE_FILE:-prod-cert.pem}
CA_FILE=${CA_FILE:-prod-ca.pem}
CLUSTER_NAME=${CLUSTER_NAME:-HQ}

oc project ${PROJECT} 2> /dev/null || oc new-project ${PROJECT}

echo "Deploying the Skupper Network"
##
## To install skupper locally:
##    curl -fL https://github.com/skupperproject/skupper-cli/releases/download/0.1.0/skupper-cli-0.1.0-linux-amd64.tgz | tar -xzf -
##
## This places the skupper executable in the current directory.  Move the executable to a location that is in the execution path.
##

SKUPPER_NAME="$(echo ${CLUSTER_NAME} | sed 's/ /_/g')"
skupper init --enable-router-console --router-console-auth openshift --id ${SKUPPER_NAME}

echo "Deploying Admin HQ Applications"

oc process -f "${DIR}/admin-config.yml" -p CLUSTER_NAME="${CLUSTER_NAME}" | oc create -f -
oc process -f "${DIR}/admin-server.yml" | oc create -f -
oc process -f "${DIR}/admin-ui.yml"  | oc create -f -
oc process -f "${DIR}/dashboard-ui.yml" | oc create -f -