#!/bin/bash

# usage:
# streams.sh -n <application-id> -r <replicas> -b <bootstrap-server> -i <application-id> -s <source-topic> -t <target-topic> -c <commit-interval-ms>
# example:
# streams.sh -n stream-application -r 1 -b demo2020-kafka-bootstrap:9092 -i my-application-id -s my-source-topic -t my-target-topic -c 1000

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
echo "DIR="$DIR

# default values
APPLICATION_NAME=my-application
REPLICAS=1
BOOTSTRAP_SERVERS=demo2020-kafka-bootstrap:9092
APPLICATION_ID=my-application-id
SOURCE_TOPIC=my-source-topic
TARGET_TOPIC=my-target-topic
COMMIT_INTERVAL_MS=5000

while getopts n:r:b:i:s:t:c: option
do
    case ${option} in
        n) APPLICATION_NAME=${OPTARG};;
        r) REPLICAS=${OPTARG};;
        b) BOOTSTRAP_SERVERS=${OPTARG};;
        i) APPLICATION_ID=${OPTARG};;
        s) SOURCE_TOPIC=${OPTARG};;
        t) TARGET_TOPIC=${OPTARG};;
        c) COMMIT_INTERVAL_MS=${OPTARG};;
    esac
done

echo "APPLICATION_NAME=$APPLICATION_NAME"
echo "REPLICAS=$REPLICAS"
echo "BOOTSTRAP_SERVERS=$BOOTSTRAP_SERVERS"
echo "APPLICATION_ID=$APPLICATION_ID"
echo "SOURCE_TOPIC=$SOURCE_TOPIC"
echo "TARGET_TOPIC=$TARGET_TOPIC"
echo "COMMIT_INTERVAL_MS=$COMMIT_INTERVAL_MS"

cp $DIR/streams.yaml $DIR/streams-deployment.yaml

yq w -i $DIR/streams-deployment.yaml metadata.name $APPLICATION_NAME
yq w -i $DIR/streams-deployment.yaml metadata.labels.app $APPLICATION_NAME
yq w -i $DIR/streams-deployment.yaml spec.selector.matchLabels.app $APPLICATION_NAME
yq w -i $DIR/streams-deployment.yaml spec.template.metadata.labels.app $APPLICATION_NAME
yq w -i $DIR/streams-deployment.yaml spec.replicas $REPLICAS

yq w -i $DIR/streams-deployment.yaml spec.template.spec.containers[0].name $APPLICATION_NAME
yq w -i $DIR/streams-deployment.yaml spec.template.spec.containers[0].env.name==BOOTSTRAP_SERVERS.value $BOOTSTRAP_SERVERS
yq w -i $DIR/streams-deployment.yaml spec.template.spec.containers[0].env.name==APPLICATION_ID.value $APPLICATION_ID
yq w -i $DIR/streams-deployment.yaml spec.template.spec.containers[0].env.name==SOURCE_TOPIC.value $SOURCE_TOPIC
yq w -i $DIR/streams-deployment.yaml spec.template.spec.containers[0].env.name==TARGET_TOPIC.value $TARGET_TOPIC
yq w -i $DIR/streams-deployment.yaml spec.template.spec.containers[0].env.name==COMMIT_INTERVAL_MS.value --tag '!!str' $COMMIT_INTERVAL_MS

oc apply -f $DIR/streams-deployment.yaml

rm $DIR/streams-deployment.yaml