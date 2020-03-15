#!/bin/bash

# reset the offset for a consumer group on a topic to the latest one
#
# usage:
# reset-tolatest.sh -g <consumer-group> -t <topic>

NAMESPACE=${KAFKA_NAMESPACE:-kafka-demo}
CLUSTER=${KAFKA_CLUSTER:-demo2020}

# default values
CONSUMER_GROUP=my-group
TOPIC=my-topic

while getopts g:t: option
do
    case ${option} in
        g) CONSUMER_GROUP=${OPTARG};;
        t) TOPIC=${OPTARG};;
    esac
done

echo "CONSUMER_GROUP=$CONSUMER_GROUP"
echo "TOPIC=$TOPIC"

echo "Current status for consumer group [$CONSUMER_GROUP] ..."
oc exec $CLUSTER-kafka-0 -c kafka -n $NAMESPACE -- bin/kafka-consumer-groups.sh \
--bootstrap-server $CLUSTER-kafka-bootstrap.$NAMESPACE.svc.cluster.local:9092 \
--group $CONSUMER_GROUP \
--describe

echo "Reset offsets to latest for consumer group [$CONSUMER_GROUP] on topic [$TOPIC] ... dry-run ..."
oc exec $CLUSTER-kafka-0 -c kafka -n $NAMESPACE -- bin/kafka-consumer-groups.sh \
--bootstrap-server $CLUSTER-kafka-bootstrap.$NAMESPACE.svc.cluster.local:9092 \
--group $CONSUMER_GROUP \
--topic $TOPIC \
--reset-offsets --to-latest \
--dry-run

read -e -p "Do you want to execute? [y|n] "

if [ $REPLY == "y" ]; then
    echo "Reset offsets to latest for consumer group [$CONSUMER_GROUP] on topic [$TOPIC] ... execute ..."
    oc exec $CLUSTER-kafka-0 -c kafka -n $NAMESPACE -- bin/kafka-consumer-groups.sh \
    --bootstrap-server $CLUSTER-kafka-bootstrap.$NAMESPACE.svc.cluster.local:9092 \
    --group $CONSUMER_GROUP \
    --topic $TOPIC \
    --reset-offsets --to-latest \
    --execute

    echo "New status for consumer group [$CONSUMER_GROUP] ..."
    oc exec $CLUSTER-kafka-0 -c kafka -n $NAMESPACE -- bin/kafka-consumer-groups.sh \
    --bootstrap-server $CLUSTER-kafka-bootstrap.$NAMESPACE.svc.cluster.local:9092 \
    --group $CONSUMER_GROUP \
    --describe
fi