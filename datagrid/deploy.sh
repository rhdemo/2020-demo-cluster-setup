#!/bin/bash
INSTANCES=${1:-2}
RESOURCE_DIR=$(dirname "$0")
set -e
oc new-project datagrid-demo || true
oc create -f $RESOURCE_DIR/datagrid-service.yaml
oc create configmap datagrid-configuration --from-file=$RESOURCE_DIR/config
oc new-app --template=datagrid-service

oc expose svc/datagrid-service --port=single=port

# Initialise default cache with game config
while [ "$(oc get statefulset datagrid-service -o jsonpath='{.status.readyReplicas}')" != "$INSTANCES" ]; do
    echo "Waiting for statefulset to have $INSTANCES readyReplicas"
    sleep 5
done

# Initate config
oc exec datagrid-service-0 -- /opt/infinispan/bin/cli.sh -c datagrid-service.datagrid-demo.svc.cluster.local:11222 --file=/config/batch
