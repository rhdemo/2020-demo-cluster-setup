#!/usr/bin/env bash

printf "\n\n######## CLEANUP ai/digit_recognition/cleanup ########\n"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT=${PROJECT:-ai}
QUAY_ORG=${QUAY_ORG:-redhatdemo}
KEY_FILE=${KEY_FILE:-prod-key.pem}
CERTIFICATE_FILE=${CERTIFICATE_FILE:-prod-cert.pem}
CA_FILE=${CA_FILE:-prod-ca.pem}

oc project ${PROJECT} 2> /dev/null || oc new-project ${PROJECT}

echo "Cleaning up digit_recognition Application"
oc delete all -l app=tf-cnn
