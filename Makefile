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

scoring: oc_login
	./scoring/deploy.sh

frontend: oc_login
	./frontend/deploy.sh

leaderboard: oc_login
	./leaderboard/deploy.sh

ml: oc_login
	./digit-recognition/deploy.sh

ml-clean: oc_login
	./digit-recognition/cleanup.sh