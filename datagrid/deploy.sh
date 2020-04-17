#!/bin/bash
INSTANCES=${1:-2}
RESOURCE_DIR=$(dirname "$0")
CONTEXT="$(oc config current-context)"
PROJECT="datagrid-demo"
REST_USER="lnd1-ffm1"
REST_PASS="lnd1-ffm1"
set -e

# Initiate config
batch_file="batch"
if [[ $CONTEXT == *"summit-aws-lnd1"* ]]; then
    if grep -q "##FRANKFURT_IP##" config/distributed-off-heap-*-london.xml; then
        echo "##FRANKFURT_IP## placeholder in config/distributed-off-heap-*-london.xml files must be replaced with Frankfurt ExternalIP 'oc get service/datagrid-service-external'"
        exit 1
    fi
    batch_file="batch-london"
fi

oc new-project $PROJECT || true
oc project $PROJECT
oc create -f $RESOURCE_DIR/datagrid-service.yaml
oc create configmap datagrid-configuration --from-file=$RESOURCE_DIR/config
oc new-app --template=datagrid-service -p NUMBER_OF_INSTANCES=$INSTANCES

# Only expose an external route on the frankfurt site
if [[ $CONTEXT == *"summit-gcp-ffm1"* ]]; then
    oc create -f service-external.yaml
fi

# Initialise default cache with game config
while [ "$(oc get statefulset datagrid-service -o jsonpath='{.status.readyReplicas}')" != "$INSTANCES" ]; do
    echo "Waiting for statefulset to have $INSTANCES readyReplicas"
    sleep 5
done

echo $batch_file
oc exec datagrid-service-0 -- /opt/infinispan/bin/cli.sh -c http://$REST_USER:$REST_PASS@datagrid-service.$PROJECT.svc.cluster.local:11222 --file=/config/$batch_file
