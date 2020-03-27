#!/bin/bash

# usage:
# consumer.sh -n <consumer-name> -r <replicas> -b <bootstrap-server> -g <consumer-group> -t <topic>
# example:
# consumer.sh -n consumer -r 1 -b demo2020-kafka-bootstrap:9092 -g my-group -t my-topic

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
echo "DIR="$DIR

# default values
CONSUMER_NAME=my-consumer
REPLICAS=1
BOOTSTRAP_SERVERS=demo2020-kafka-bootstrap:9092
GROUP_ID=my-group
TOPIC=my-topic

while getopts n:r:b:g:t: option
do
    case ${option} in
        n) CONSUMER_NAME=${OPTARG};;
        r) REPLICAS=${OPTARG};;
        b) BOOTSTRAP_SERVERS=${OPTARG};;
        g) GROUP_ID=${OPTARG};;
        t) TOPIC=${OPTARG};;
    esac
done

echo "CONSUMER_NAME=$CONSUMER_NAME"
echo "REPLICAS=$REPLICAS"
echo "BOOTSTRAP_SERVERS=$BOOTSTRAP_SERVERS"
echo "GROUP_ID=$GROUP_ID"
echo "TOPIC=$TOPIC"

cp $DIR/consumer.yaml $DIR/consumer-deployment.yaml

yq w -i $DIR/consumer-deployment.yaml metadata.name $CONSUMER_NAME
yq w -i $DIR/consumer-deployment.yaml metadata.labels.app $CONSUMER_NAME
yq w -i $DIR/consumer-deployment.yaml spec.selector.matchLabels.app $CONSUMER_NAME
yq w -i $DIR/consumer-deployment.yaml spec.template.metadata.labels.app $CONSUMER_NAME
yq w -i $DIR/consumer-deployment.yaml spec.replicas $REPLICAS

yq w -i $DIR/consumer-deployment.yaml spec.template.spec.containers[0].name $CONSUMER_NAME
yq w -i $DIR/consumer-deployment.yaml spec.template.spec.containers[0].env.name==BOOTSTRAP_SERVERS.value $BOOTSTRAP_SERVERS
yq w -i $DIR/consumer-deployment.yaml spec.template.spec.containers[0].env.name==TOPIC.value $TOPIC
yq w -i $DIR/consumer-deployment.yaml spec.template.spec.containers[0].env.name==GROUP_ID.value $GROUP_ID

oc apply -f $DIR/consumer-deployment.yaml

rm $DIR/consumer-deployment.yaml