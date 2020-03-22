#!/bin/bash

NAMESPACE=${KAFKA_NAMESPACE:-kafka-demo}
CLUSTER=${KAFKA_CLUSTER:-demo2020}

# delete Kafka topics
echo "Deleting KafkaTopics..."
oc delete kafkatopic --all -n $NAMESPACE
echo "...deleted"
# delete Kafka Mirror Maker 2
echo "Deleting Kafka Mirror Maker 2..."
oc delete kafkamirrormaker2 $CLUSTER-mirror-maker-2 -n $NAMESPACE
echo "...deleted"
# delete Kafka cluster
echo "Deleting Kafka cluster..."
oc delete kafka $CLUSTER -n $NAMESPACE
echo "...deleted"