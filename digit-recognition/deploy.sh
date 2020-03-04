#!/usr/bin/env bash

printf "\n\n######## frontend/digit_recognition/deploy ########\n"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT=${PROJECT:-frontend}
QUAY_ORG=${QUAY_ORG:-redhatdemo}
KEY_FILE=${KEY_FILE:-prod-key.pem}
CERTIFICATE_FILE=${CERTIFICATE_FILE:-prod-cert.pem}
CA_FILE=${CA_FILE:-prod-ca.pem}

oc project ${PROJECT} 2> /dev/null || oc new-project ${PROJECT}

echo "Deploying digit_recognition Application"
ML_PARAMS="IMAGE_REPOSITORY=quay.io/${QUAY_ORG}/2020-digit-recognition:latest \
    -p REPLICAS=1 \
    -p TF_CPP_MIN_VLOG_LEVEL=2 \
    -p APPLICATION_NAME=tf-cnn"
oc process -f "${DIR}/deployment.yml" ${ML_PARAMS} \
  | oc create -f -
