#!/bin/bash

NAMESPACE=${KAFKA_NAMESPACE:-kafka-demo}
OLM_INSTALL=${KAFKA_OLM_INSTALL:-false}

if [ "$OLM_INSTALL" == "true" ]; then
    # uninstall operator
    oc delete subscriptions.operators.coreos.com strimzi-kafka-operator -n $NAMESPACE
    oc delete clusterserviceversion strimzi-cluster-operator.v0.11.1 -n $NAMESPACE
    oc delete catalogsourceconfig installed-community-$NAMESPACE -n openshift-marketplace
    oc delete operatorgroup strimzi-kafka-operator -n $NAMESPACE
fi

# deleting "all" Strimzi resources
echo "Deleting all Strimzi resources..."
oc delete all -l app=strimzi -n $NAMESPACE
echo "...deleted"

# deleting CRDs, service account, cluster roles, cluster role bindings, 
echo "Deleting CRDs, service accounts, cluster roles, cluster role bindings..."
oc delete configmap -l app=strimzi -n $NAMESPACE
oc delete crd -l app=strimzi
oc delete serviceaccount -l app=strimzi -n $NAMESPACE
oc delete clusterrole -l app=strimzi
oc delete clusterrolebinding -l app=strimzi
oc delete rolebinding -l app=strimzi -n $NAMESPACE
echo "...deleted"