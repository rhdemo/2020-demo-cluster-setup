#!/bin/bash

NAMESPACE=${KAFKA_NAMESPACE:-kafka-demo}
CLUSTER=${KAFKA_CLUSTER:-demo2020}

# delete Kafka topics
oc delete kafkatopic my-topic -n $NAMESPACE
# delete Kafka cluster
oc delete kafka $CLUSTER -n $NAMESPACE