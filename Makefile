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

leaderboard_login: 
	./leaderboard/installer ocLogin

leaderboard_project:	leaderboard_login
	./leaderboard/installer createOrUseProject

leaderboard_postgresql:	leaderboard_project
	./leaderboard/installer installPostgresql

leaderboard_nexus:	leaderboard_project
	./leaderboard/installer installNexus

leaderboard_pipelines:	leaderboard_project
	./leaderboard/installer installPipelines

leaderboard_install_api:	leaderboard_project
	./leaderboard/installer installLeaderboardAPI

leaderboard_deploy_api:
	./leaderboard/installer deployLeaderboardAPI

leaderboard_uninstall_api:
	./leaderboard/installer installLeaderboardAPI --clean

leaderboard_install_aggregator:		leaderboard_project
	./leaderboard/installer installLeaderboard

leaderboard_uninstall_aggregator:
	./leaderboard/installer installLeaderboard --clean

leaderboard_deploy_aggregator:
	./leaderboard/installer deployLeaderboard

leaderboard_install_messaging:	leaderboard_project
	./leaderboard/installer installLeaderboardMessaging

leaderboard_deploy_messaging:
	./leaderboard/installer deployLeaderboardMessaging

leaderboard_uninstall_messaging:
	./leaderboard/installer installLeaderboardMessaging --clean

leaderboard_install_broadcast:		leaderboard_project
	./leaderboard/installer installLeaderboardBroadcast

leaderboard_deploy_broadcast:	leaderboard_install_broadcast
	./leaderboard/installer deployLeaderboardBroadcast

leaderboard_uninstall_broadcast:
	./leaderboard/installer installLeaderboardBroadcast --clean

leaderboard_install_all:	leaderboard_project
	leaderboard_install_api
	leaderboard_install_aggregator
	leaderboard_install_messaging
	leaderboard_install_broadcast

leaderboard_deploy_all:	
	leaderboard_deploy_api
	leaderboard_deploy_aggregator
	leaderboard_deploy_messaging
	leaderboard_deploy_broadcast

leaderboard_uninstall_all:
	leaderboard_install_api --clean
	leaderboard_install_aggregator --clean
	leaderboard_install_messaging --clean
	leaderboard_install_broadcast --clean

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

