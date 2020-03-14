#!/bin/bash

# usage:
# producer.sh -n <producer-name> -r <replicas> -d <delay_ms> -b <bootstrap-server> -t <topic> -m <message>
# example:
# producer.sh -n producer -r 1 -d 1000 -b demo2020-kafka-bootstrap:9092 -t topic -m "Hello from demo2"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
echo "DIR="$DIR

# default values
PRODUCER_NAME=my-producer-demo2020
REPLICAS=1
DELAY_MS=1000
BOOTSTRAP_SERVERS=demo2020-kafka-bootstrap:9092
TOPIC=my-topic
MESSAGE="Hello world"

while getopts n:r:d:b:t:m: option
do
    case ${option} in
        n) PRODUCER_NAME=${OPTARG};;
        r) REPLICAS=${OPTARG};;
        d) DELAY_MS=${OPTARG};;
        b) BOOTSTRAP_SERVERS=${OPTARG};;
        t) TOPIC=${OPTARG};;
        m) MESSAGE=${OPTARG};;
    esac
done

echo "PRODUCER_NAME=$PRODUCER_NAME"
echo "REPLICAS=$REPLICAS"
echo "DELAY_MS=$DELAY_MS"
echo "BOOTSTRAP_SERVERS=$BOOTSTRAP_SERVERS"
echo "TOPIC=$TOPIC"
echo "MESSAGE=$MESSAGE"

cp $DIR/producer.yaml $DIR/producer-deployment.yaml

yq w -i $DIR/producer-deployment.yaml metadata.name $PRODUCER_NAME
yq w -i $DIR/producer-deployment.yaml metadata.labels.app $PRODUCER_NAME
yq w -i $DIR/producer-deployment.yaml spec.selector.matchLabels.app $PRODUCER_NAME
yq w -i $DIR/producer-deployment.yaml spec.template.metadata.labels.app $PRODUCER_NAME
yq w -i $DIR/producer-deployment.yaml spec.replicas $REPLICAS

yq w -i $DIR/producer-deployment.yaml spec.template.spec.containers[0].name $PRODUCER_NAME
yq w -i $DIR/producer-deployment.yaml spec.template.spec.containers[0].env.name==BOOTSTRAP_SERVERS.value $BOOTSTRAP_SERVERS
yq w -i $DIR/producer-deployment.yaml spec.template.spec.containers[0].env.name==TOPIC.value $TOPIC
yq w -i $DIR/producer-deployment.yaml spec.template.spec.containers[0].env.name==DELAY_MS.value --tag '!!str' $DELAY_MS
# using sed instead for yq, due to https://github.com/mikefarah/yq/issues/387
#yq w -i $DIR/producer-deployment.yaml spec.template.spec.containers[0].env.name==MESSAGE.value $MESSAGE
sed -i "s/message/\"$MESSAGE\"/" $DIR/producer-deployment.yaml

#oc apply -f $DIR/producer-deployment.yaml

#rm $DIR/producer-deployment.yaml