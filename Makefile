ENV_FILE := .env
include ${ENV_FILE}
export $(shell sed 's/=.*//' ${ENV_FILE})

# NOTE: the actual commands here have to be indented by TABs
.PHONY: oc_login
oc_login:
	oc login ${OC_URL} -u ${OC_USER} -p ${OC_PASSWORD} --insecure-skip-tls-verify=true

datagrid: oc_login
	./datagrid/deploy.sh

kafka: oc_login
	./kafka/deploy_kafka.sh

kafka_mirror_maker: oc_login
	./kafka/deploy-kafka-mirror-maker.sh

admin: oc_login
	./admin-hq/deploy.sh

admin-undeploy: oc_login
	./admin-hq/undeploy.sh

leaderboard_project:	oc_login
	./leaderboard/installer createProjects

leaderboard_postgresql:	oc_login
	./leaderboard/installer installPostgresql

leaderboard_nexus:	oc_login
	./leaderboard/installer installNexus

leaderboard_pipelines:	oc_login
	./leaderboard/installer installPipelines

leaderboard_topics:	oc_login
	./leaderboard/installer createTopics

leaderboard_install_api:
	./leaderboard/installer installLeaderboardAPI

leaderboard_deploy_api:	leaderboard_install_api
	./leaderboard/installer deployLeaderboardAPI

leaderboard_install_aggregator:	
	./leaderboard/installer installLeaderboard

leaderboard_deploy_aggregator:
	./leaderboard/installer deployLeaderboard

visualization: oc_login
	./visualization/deploy.sh

scoring: oc_login
	./scoring/deploy.sh

scoring-undeploy: oc_login
	./scoring/undeploy.sh

frontend: oc_login
	./frontend/deploy.sh

frontend-undeploy: oc_login
	./frontend/undeploy.sh

ml: oc_login
	./digit-recognition/deploy.sh

ml-clean: oc_login
	./digit-recognition/cleanup.sh

disconnect: oc_login
	./frontend/disconnect.sh

reconnect: oc_login
	./frontend/reconnect.sh

