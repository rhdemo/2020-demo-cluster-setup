# RH Summit 2020 Demo Cluster Setup

This repo contains all scripts to prepare an OpenShift 4 cluster to run the 2020 Keynote Demo 4.

## Setup

Create a `.env` file with all the required environment variables. An example env file [.env.example](.env.example) is included.

```bash
cp .env.example .env
```

Test that you can login to the server with

```bash
make oc_login
```

### Adding scripts

Just create a sub directory, add a shell script and resource files and execute them via the Makefile.
Note that the commands in a `Makefile` have to be indented by tabs.
Also add a short description to this `README.md`


## Front End Applications and Socket Servers
To configure an admin password, set the `ADMIN_PASSWORD` in the `.env` file.
To configure the training application, set the appropriate s3 environment variables
for your s3 bucket as shown in the `.env.example`.  Leaving the s3 variables 
will run the frontend without saving the training data to s3.
```
make frontend
```
Game UI: http://game-frontend.cluster-host
Admin UI: http://admin-frontend.cluster-host (blank password unless `ADMIN_PASSWORD` was set in the .env file)

## Strimzi and Apache Kafka

The Apache Kafka related deployment is made by:

* The Strimzi operators, starting from the Cluster operator to the Topic and User operators
* The Apache Kafka cluster deployment (alongside with a Zookeeper cluster)
* The monitoring infrastructure made by Prometheus, the related alert manager and Grafana with Kafka and Zookeeper dashboards

To deploy the Apache Kafka infrastructure:

```bash
make kafka
```
