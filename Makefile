ENV_FILE := .env
include ${ENV_FILE}
export $(shell sed 's/=.*//' ${ENV_FILE})

# NOTE: the actual commands here have to be indented by TABs
.PHONY: oc_login
oc_login:
	oc login ${OC_URL} -u ${OC_USER} -p ${OC_PASSWORD} --insecure-skip-tls-verify=true

.PHONY: frontend
frontend: oc_login
	./frontend/deploy.sh

datagrid: oc_login
	./datagrid/deploy.sh

kafka: oc_login
	./kafka/deploy_kafka.sh