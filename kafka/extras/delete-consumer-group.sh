#!/bin/bash
set -x

# delete a consumer group
#
# usage:
# delete-consumer-group.sh -g <consumer-group>
# example: delete-consumer-group.sh -g my-group

NAMESPACE=${KAFKA_NAMESPACE:-kafka-demo}
CLUSTER=${KAFKA_CLUSTER:-demo2020}

# default values
CONSUMER_GROUP=my-group

while getopts g: option
do
    case ${option} in
        g) CONSUMER_GROUP=${OPTARG};;
    esac
done

echo "CONSUMER_GROUP=$CONSUMER_GROUP"

echo "Current status for consumer group [$CONSUMER_GROUP] ..."
oc exec $CLUSTER-kafka-0 -c kafka -n $NAMESPACE -- bin/kafka-consumer-groups.sh \
--bootstrap-server $CLUSTER-kafka-bootstrap.$NAMESPACE.svc.cluster.local:9092 \
--group $CONSUMER_GROUP \
--describe

read -e -p "Do you want to delete it? [y|n] "

if [ $REPLY == "y" ]; then
    echo "Deleting $CONSUMER_GROUP ..."
    oc exec $CLUSTER-kafka-0 -c kafka -n $NAMESPACE -- bin/kafka-consumer-groups.sh \
    --bootstrap-server $CLUSTER-kafka-bootstrap.$NAMESPACE.svc.cluster.local:9092 \
    --group $CONSUMER_GROUP \
    --delete
fi