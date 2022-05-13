#!/usr/bin/bash

set -ex

oc login --insecure-skip-tls-verify --token ${OCP_SA_TOKEN} ${OCP_URL}

VALUES_FILE=$(test -d ${HELM_CHART_DIR} && find ${HELM_CHART_DIR} -name "values.y*ml")
if [[ -f "${VALUES_FILE}" ]]
then
    DEPLOY_VALUES_FILE="--values ${VALUES_FILE}"
fi

ENV_VALUES_FILE=$(test -d ${HELM_CHART_DIR} && find ${HELM_CHART_DIR} -name "values-${DEPLOY_ENV}.y*ml")
if [[ -f "${ENV_VALUES_FILE}" ]]
then
    DEPLOY_ENV_VALUES_FILE="--values ${ENV_VALUES_FILE}"
fi

if [[ ! -z ${DEPLOY_VALUES_FILE} || ! -z ${DEPLOY_ENV_VALUES_FILE} ]]
then
    OCP_PROJECT_NAME="${SYSTEM_NAME}-${TEAM_NAME}-${DEPLOY_ENV}"
    helm upgrade --install --wait ${COMPONENT_NAME} ${HELM_CHART_DIR} ${DEPLOY_VALUES_FILE} ${DEPLOY_ENV_VALUES_FILE} -n ${OCP_PROJECT_NAME}
fi

set +ex