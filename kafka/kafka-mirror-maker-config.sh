#!/bin/bash

CLUSTER=${KAFKA_CLUSTER:-demo2020}
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

lbs=$DIR/clusters.lbs

i=0
while IFS='=' read key value
do
    # update mirrors configuration starting from i=0
    yq w -i $DIR/mirror-maker/$CLUSTER-kafka-mirror-maker.yaml spec.mirrors[$i].sourceCluster $key
    yq w -i $DIR/mirror-maker/$CLUSTER-kafka-mirror-maker.yaml spec.mirrors[$i].targetCluster hq
    yq w -i $DIR/mirror-maker/$CLUSTER-kafka-mirror-maker.yaml spec.mirrors[$i].sourceConnector.config[replication.factor] 1
    yq w -i $DIR/mirror-maker/$CLUSTER-kafka-mirror-maker.yaml spec.mirrors[$i].sourceConnector.config[offset-syncs.topic.replication.factor] 1
    yq w -i $DIR/mirror-maker/$CLUSTER-kafka-mirror-maker.yaml spec.mirrors[$i].sourceConnector.config[sync.topic.acls.enabled] false
    yq w -i $DIR/mirror-maker/$CLUSTER-kafka-mirror-maker.yaml spec.mirrors[$i].heartbeatConnector.config[heartbeats.topic.replication.factor] 1
    yq w -i $DIR/mirror-maker/$CLUSTER-kafka-mirror-maker.yaml spec.mirrors[$i].checkpointConnector.config[checkpoints.topic.replication.factor] 1
    yq w -i $DIR/mirror-maker/$CLUSTER-kafka-mirror-maker.yaml spec.mirrors[$i].topicsPattern ".*"
    yq w -i $DIR/mirror-maker/$CLUSTER-kafka-mirror-maker.yaml spec.mirrors[$i].groupsPattern ".*"

    # jump to i=1 for updating clusters (i=0 is for hq)
    ((i++))
    yq w -i $DIR/mirror-maker/$CLUSTER-kafka-mirror-maker.yaml spec.clusters[$i].alias $key
    yq w -i $DIR/mirror-maker/$CLUSTER-kafka-mirror-maker.yaml spec.clusters[$i].bootstrapServers $value
    yq w -i $DIR/mirror-maker/$CLUSTER-kafka-mirror-maker.yaml spec.clusters[$i].config[config.storage.replication.factor] 1
    yq w -i $DIR/mirror-maker/$CLUSTER-kafka-mirror-maker.yaml spec.clusters[$i].config[offset.storage.replication.factor] 1
    yq w -i $DIR/mirror-maker/$CLUSTER-kafka-mirror-maker.yaml spec.clusters[$i].config[status.storage.replication.factor] 1
done < "$lbs"
