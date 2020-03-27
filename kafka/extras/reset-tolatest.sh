#!/bin/bash
set -x

# reset the offset for a consumer group or all groups on a topic to the latest one
#
# usage:
# reset-tolatest.sh [-g <consumer-group>|-a] -t <topic>
# example: reset-tolatest.sh -g my-group -t my-topic
# example: reset-tolatest.sh -a -t my-topic

NAMESPACE=${KAFKA_NAMESPACE:-kafka-demo}
CLUSTER=${KAFKA_CLUSTER:-demo2020}

# default values
CONSUMER_GROUP=my-group
TOPIC=my-topic
ALL_GROUPS=false

while getopts g:t:a option
do
    case ${option} in
        g) CONSUMER_GROUP=${OPTARG};;
        t) TOPIC=${OPTARG};;
        a) ALL_GROUPS=true
    esac
done

echo "CONSUMER_GROUP=$CONSUMER_GROUP"
echo "TOPIC=$TOPIC"
echo "ALL_GROUPS=$ALL_GROUPS"

if [ "$ALL_GROUPS" == "false" ]; then
    GROUP="--group $CONSUMER_GROUP"
    GROUP_MESSAGE="consumer group [$CONSUMER_GROUP]"
else
    GROUP="--all-groups"
    GROUP_MESSAGE="all consumer groups"
fi

echo "Current status for $GROUP_MESSAGE ..."
oc exec $CLUSTER-kafka-0 -c kafka -n $NAMESPACE -- bin/kafka-consumer-groups.sh \
--bootstrap-server $CLUSTER-kafka-bootstrap.$NAMESPACE.svc.cluster.local:9092 \
$GROUP \
--describe

echo "Reset offsets to latest for $GROUP_MESSAGE on topic [$TOPIC] ... dry-run ..."
oc exec $CLUSTER-kafka-0 -c kafka -n $NAMESPACE -- bin/kafka-consumer-groups.sh \
--bootstrap-server $CLUSTER-kafka-bootstrap.$NAMESPACE.svc.cluster.local:9092 \
$GROUP \
--topic $TOPIC \
--reset-offsets --to-latest \
--dry-run

read -e -p "Do you want to execute? [y|n] "

if [ $REPLY == "y" ]; then
    echo "Reset offsets to latest for $GROUP_MESSAGE on topic [$TOPIC] ... execute ..."
    oc exec $CLUSTER-kafka-0 -c kafka -n $NAMESPACE -- bin/kafka-consumer-groups.sh \
    --bootstrap-server $CLUSTER-kafka-bootstrap.$NAMESPACE.svc.cluster.local:9092 \
    --group $CONSUMER_GROUP \
    --topic $TOPIC \
    --reset-offsets --to-latest \
    --execute

    echo "New status for $GROUP_MESSAGE ..."
    oc exec $CLUSTER-kafka-0 -c kafka -n $NAMESPACE -- bin/kafka-consumer-groups.sh \
    --bootstrap-server $CLUSTER-kafka-bootstrap.$NAMESPACE.svc.cluster.local:9092 \
    --group $CONSUMER_GROUP \
    --describe
fi