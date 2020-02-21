#!/bin/bash

# usage:
# consumer.sh <consumer-name> <bootstrap-server> <consumer-group> <topic>
# example:
# consumer.sh consumer my-cluster-kafka-bootstrap:9092 my-group demo2.my-topic

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
echo "DIR="$DIR

CONSUMER_NAME=$1
BOOTSTRAP_SERVERS=$2
GROUP_ID=$3
TOPIC=$4

cat  $DIR/consumer.yaml \
| sed "s/consumer_name/$CONSUMER_NAME/" \
| sed "s/bootstrap_servers/$BOOTSTRAP_SERVERS/" \
| sed "s/groupid/$GROUP_ID/" \
| sed "s/topic/$TOPIC/" \
| oc apply -f -