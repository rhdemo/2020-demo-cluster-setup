#!/bin/bash

# usage:
# producer.sh <producer-name> <bootstrap-server> <topic> <message>

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
echo "DIR="$DIR

PRODUCER_NAME=$1
BOOTSTRAP_SERVERS=$2
TOPIC=$3
MESSAGE=$4

cat  $DIR/producer.yaml \
| sed "s/producer_name/$PRODUCER_NAME/" \
| sed "s/bootstrap_servers/$BOOTSTRAP_SERVERS/" \
| sed "s/topic/$TOPIC/" \
| sed "s/message/$MESSAGE/" \
| oc apply -f -