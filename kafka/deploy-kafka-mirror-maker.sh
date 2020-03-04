#!/bin/bash

echo "KAFKA_NAMESPACE=" $KAFKA_NAMESPACE
echo "KAFKA_CLUSTER=" $KAFKA_CLUSTER

NAMESPACE=${KAFKA_NAMESPACE:-kafka-demo}
CLUSTER=${KAFKA_CLUSTER:-demo2020}
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

sed "s/my-mirror-maker-2/$CLUSTER-mirror-maker-2/" $DIR/mirror-maker/kafka-mirror-maker.yaml > $DIR/mirror-maker/$CLUSTER-kafka-mirror-maker.yaml
sed -i "s/my-cluster/$CLUSTER/" $DIR/mirror-maker/$CLUSTER-kafka-mirror-maker.yaml

# run script for configuring Kafka Mirror Maker
. $DIR/kafka-mirror-maker-config.sh

oc apply -f $DIR/mirror-maker/$CLUSTER-kafka-mirror-maker.yaml -n $NAMESPACE

# delay for allowing cluster operator to create the Kafka MirrorMaker2 deployment
sleep 5

echo "Waiting for Kafka MirrorMaker2 to be ready..."
oc rollout status deployment/$CLUSTER-mirror-maker-2-mirrormaker2 -w -n $NAMESPACE
echo "...Kafka MirrorMaker2 ready"

rm $DIR/mirror-maker/$CLUSTER-kafka-mirror-maker.yaml