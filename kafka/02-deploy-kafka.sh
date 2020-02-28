#!/bin/bash

NAMESPACE=${KAFKA_NAMESPACE:-kafka-demo}
CLUSTER=${KAFKA_CLUSTER:-demo2020}
VERSION=${KAFKA_VERSION:-2.4.0}
EXPOSE=${KAFKA_EXPOSE:-false}
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

sed "s/my-cluster/$CLUSTER/" $DIR/cluster/kafka-persistent-with-metrics.yaml > $DIR/cluster/$CLUSTER-kafka-persistent-with-metrics.yaml
sed -i "s/my-kafka-version/$VERSION/" $DIR/cluster/$CLUSTER-kafka-persistent-with-metrics.yaml

# if Kafka has to be exposed, an external listener is added
if [ "$EXPOSE" == "true" ]; then
    yq w -i $DIR/cluster/$CLUSTER-kafka-persistent-with-metrics.yaml spec.kafka.listeners.external.type loadbalancer
    yq w -i $DIR/cluster/$CLUSTER-kafka-persistent-with-metrics.yaml spec.kafka.listeners.external.tls false
fi

oc apply -f $DIR/cluster/$CLUSTER-kafka-persistent-with-metrics.yaml -n $NAMESPACE

# delay for allowing cluster operator to create the ZooKeeper statefulset
sleep 5

zkReplicas=$(oc get kafka $CLUSTER -o jsonpath="{.spec.zookeeper.replicas}" -n $NAMESPACE)
echo "Waiting for Zookeeper cluster to be ready..."
readyReplicas="0"
while [ "$readyReplicas" != "$zkReplicas" ]
do
    sleep 2
    readyReplicas=$(oc get statefulsets $CLUSTER-zookeeper -o jsonpath="{.status.readyReplicas}" -n $NAMESPACE)
done
echo "...Zookeeper cluster ready"

kReplicas=$(oc get kafka $CLUSTER -o jsonpath="{.spec.kafka.replicas}" -n $NAMESPACE)

# waiting for the LB address
if [ "$EXPOSE" == "true" ]; then
    echo "Waiting LB address for $CLUSTER-kafka-external-bootstrap service..."
    lbAddress=""
    while [ -z "$lbAddress" ]
    do
        lbAddress=$(oc get svc $CLUSTER-kafka-external-bootstrap -o jsonpath='{.status.loadBalancer.ingress[].hostname}')
        echo "... $lbAddress"
        sleep 5
    done
    echo "...LB address for $CLUSTER-kafka-external-bootstrap service ready"

    for ((i=0; i<kReplicas; i++))
    do
        echo "Waiting LB address for $CLUSTER-kafka-$i service..."
        lbAddress=""
        while [ -z "$lbAddress" ]
        do
            lbAddress=$(oc get svc $CLUSTER-kafka-$i -o jsonpath='{.status.loadBalancer.ingress[].hostname}')
            echo "... $lbAddress"
            sleep 5
        done
        echo "...LB address for $CLUSTER-kafka-$i service ready"
    done
fi

# delay for allowing cluster operator to create the Kafka statefulset
sleep 5

echo "Waiting for Kafka cluster to be ready..."
readyReplicas="0"
while [ "$readyReplicas" != "$kReplicas" ]
do
    sleep 2
    readyReplicas=$(oc get statefulsets $CLUSTER-kafka -o jsonpath="{.status.readyReplicas}" -n $NAMESPACE)
done
echo "...Kafka cluster ready"

# delay for allowing cluster operator to create the Entity Operator deployment
sleep 5

echo "Waiting for entity operator to be ready..."
oc rollout status deployment/$CLUSTER-entity-operator -w -n $NAMESPACE
echo "...entity operator ready"

# delay for allowing cluster operator to create the Kafka Exporter deployment
sleep 5

echo "Waiting for Kafka exporter to be ready..."
oc rollout status deployment/$CLUSTER-kafka-exporter -w -n $NAMESPACE
echo "...Kafka exporter ready"

rm $DIR/cluster/$CLUSTER-kafka-persistent-with-metrics.yaml

# waiting finally Kafka is ready
kStatus="NotReady"
while [ "$kStatus" != "Ready" ]
do
    kStatus=$(oc get kafka $CLUSTER -o jsonpath='{.status.conditions[].type}')
    sleep 2
done

if [ "$EXPOSE" == "true" ]; then
    # printing external access service for Kafka Mirror Maker
    svcExternalBootstrapHostname=$(oc get kafka $CLUSTER -o jsonpath='{.status.listeners[?(@.type == "external")].addresses[].host}')
    svcExternalBootstrapPort=$(oc get kafka $CLUSTER -o jsonpath='{.status.listeners[?(@.type == "external")].addresses[].port}')
    echo "$CLUSTER - svc external bootstrap: $svcExternalBootstrapHostname:$svcExternalBootstrapPort"
fi