# RH Summit 2020 Demo Cluster Setup

This repo contains all scripts to prepare an OpenShift 4 cluster to run the 2020 Live Keynote Demo.

## Setup

Required tooling includes [oc](https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/) to deploy to OpenShift, [yq](https://github.com/mikefarah/yq) for Kafka, and [skupper](https://github.com/skupperproject/skupper-cli/releases/download/0.1.0/) for the messaging interconnect.

Create a `.env` file with all the required environment variables. An example env file [.env.example](.env.example) is included.

```bash
cp .env.example .env
```

Test that you can login to the server with

```bash
make oc_login
```

## Strimzi and Apache Kafka

The Apache Kafka related deployment is made by:

* The Strimzi operators, starting from the Cluster operator to the Topic and User operators
* The Apache Kafka cluster deployment (alongside with a Zookeeper cluster)
* The monitoring infrastructure made by Prometheus, the related alert manager and Grafana with Kafka and Zookeeper dashboards

To deploy the Apache Kafka infrastructure:

```bash
make kafka
```

> In order to deploy Kafka, this version of the [yq](https://github.com/mikefarah/yq) tool is needed.


## HQ Applications

### Kafka
This will create the `kafka-demo` project.  See above for additional info.
Before deploying the Kafka cluster on HQ, change the number of partitions in the `KafkaTopic` (in the `kafka/cluster/kafka-topics.yaml` folder) to 300 because it will contain an aggregation of messages coming from the clusters at the edge.

```
make kafka
```

When the Kafka cluster is deployed, the next step is to deploy Kafka Mirror Maker 2 for mirroring data from all the clusters at the edge.
Before running the deployment, be sure that the `clusters.lbs` file exists and it contains the Load Balancer addresses for all the Kafka clusters already deployed at the edge that have to be mirrored to the HQ.

```
make kafka_mirror_maker
```

### Datagrid Service
This will create the `datagrid-demo` project and 2 pods for the datagrid service.  Provides storage for the game state and bot config which will be pushed to the edge clusters.
```
make datagrid
```

### Admin UI and Services
* `admin-server` 2 pods.  Service which sets global settings and sends AMQP messages to the edge applications.
* `admin-ui` 2 pods. Service for the Admin UI application which connects to the admin-server internally.  Exposed via route.
* `dashboard-ui` 2 pods. Service for the UI application which shows the 3d rendered global map of clusters.
* skupper service interconnects across all edges and admin.
 
To configure an admin username and password, set the `ADMIN_USERNAME` and `ADMIN_PASSWORD` in the `.env` file.
for the frontend to show the currently connected cluster, set the `CLUSTER_NAME` in the `.env` file.
```
make admin
```
Admin UI: http://ui-admin-hq.hub-cluster (blank username/password unless set in the .env file)
 
### Leaderboard Services
Creates services to consume data from mirrored kafka streams and aggregate and store them in Postgres.  Also deploys services to allow access to that data from the Leaderboard UI.
```
make leaderboard_project
make leaderboard_install_postgresql
make leaderboard_install_all
```

### Leaderboard UI
Creates the `leaderboard` project if not created and the UI application which polls the leaderboard services for display.
```
make visualization
```

 
## Edge Applications
Edge clusters for the 2020 demonstration utilized clusters from IBM ROKS, Azure, GCP, and AWS in San Francisco, New York, Sao Paulo, London, Frankfurt, Singapore, and Sydney.  Skupper should be available on Admin-HQ before installing edge.
 
The Edge clusters require
* datagrid
* kafka
* digit recognition service
* scoring service
* frontend applications
    * admin-edge
    * bot-server
    * phone-server
    * phone-ui
    * skupper
    
### Kafka 
This will create the `kafka-demo` project.  See above for additional info.
Before deploying the Kafka cluster on HQ, be sure that the number of partitions in the `KafkaTopic` (in the `kafka/cluster/kafka-topics.yaml` folder) is the 50 default value.

```
make kafka
```

When the Kafka cluster is deployed, the script gets the Load Balancer address and append it into a `clusters.lbs` file.
This file will contains all the Load Balancer addresses related to the edge clusters where Kafka is deployed that have to be mirrored to the HQ.

### Datagrid Service
This will create the `datagrid-demo` project and 2 pods for the datagrid service.  Provides edge storage as a cache with notifications to frontend services.
```
make datagrid
```
London is backed-up to Frankfurt via remote store and additional scripting is done for those clusters. For detailed
deployment instructions please see the [Data Grid README](datagrid/README.md).

### Digit Recognition Service
This will create the `ai` project and 12 pods for the digit-recognition service.
```
make ml
```

### Scoring Service
This will create the `scoring` project and 5 pods for the scoring service.
```
make quarkus-scoring
```

### Front End UI and Services
This will create the `frontend` project and services.  For the frontend to show the currently connected cluster, set the `CLUSTER_NAME` in the `.env` file.
* `admin-edge` 2 pods.  Service which listens for AMQP messages from the global admin application and writes to Infinispan
* `bot-server` 2 pods.  Service which plays the game for testing purposes
* `phone-server` 5 pods.  Service for the game accessible via websocket.
* `phone-ui` 5 pods. Service for the UI application which connects to the phone-server internally.  Also exposed via route.
* skupper service interconnects across all edges and admin.
     
```
make frontend
```
Game is accessible via `http://game-frontend.edge-host` 
 
 
## Adding deployment scripts

Just create a sub directory, add a shell script and resource files and execute them via the Makefile.
Note that the commands in a `Makefile` have to be indented by tabs.
Also add a short description to this `README.md`
