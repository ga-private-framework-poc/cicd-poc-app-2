#!/usr/bin/bash

set -ex

echo 'Create OCP SDLC Environments'

oc version
helm version
jq --version

oc login --insecure-skip-tls-verify -u ${OCP_USER} -p ${OCP_CREDS} ${OCP_URL}

ENV_ARRAY=$(echo "${DEV_ENVIRONMENT} $(echo ${TEST_ENVIRONMENTS} | jq -jr  '" " + .[]')" | xargs)
echo "ENV_ARRAY: ${ENV_ARRAY}"
for ENV in ${ENV_ARRAY}
do
    OCP_PROJECT_NAME="${SYSTEM_NAME}-${TEAM_NAME}-${ENV}"
    if [[ -z $(oc get --ignore-not-found --no-headers project ${OCP_PROJECT_NAME}) ]]
    then
        echo 'dev OCP Project not found: CREATING'
        oc new-project ${OCP_PROJECT_NAME}
    else
        echo "${ENV} OCP Project ${OCP_PROJECT_NAME} found: SKIPPING"
    fi

    PULL_SECRET_NAME=${SYSTEM_NAME}-${TEAM_NAME}-pull-secret
    if [[ -z $(oc get secret --ignore-not-found --no-headers ${PULL_SECRET_NAME} -n ${OCP_PROJECT_NAME}) ]]
    then
        oc create secret docker-registry ${PULL_SECRET_NAME} \
            --docker-username=${IMAGE_REGISTRY_USERNAME} \
            --docker-password=${IMAGE_REGISTRY_PWD} \
            --docker-server=${IMAGE_REGISTRY_URL} \
            -n ${OCP_PROJECT_NAME}
    fi

    SERVICE_ACCOUNT_NAME=${SYSTEM_NAME}-${TEAM_NAME}-service-account
    if [[ -z $(oc get sa --ignore-not-found --no-headers ${SERVICE_ACCOUNT_NAME} -n ${OCP_PROJECT_NAME}) ]]
    then
        oc create sa ${SERVICE_ACCOUNT_NAME} -n ${OCP_PROJECT_NAME}
        oc policy add-role-to-user edit -z ${SERVICE_ACCOUNT_NAME} -n ${OCP_PROJECT_NAME}
    fi

    oc delete quota --wait --ignore-not-found -l systemid=${SYSTEM_NAME} -n ${OCP_PROJECT_NAME}
    sleep 2

    RQ_SIZE=$(echo ${RESOURCE_QUOTAS} | jq -r .${ENV})
    RQ_FILE="${GITHUB_ACTION_PATH}/resources/resource-quotas/${RQ_SIZE}.yml"
    if [[ ! -z "${RQ_SIZE}" && -f "${RQ_FILE}" ]]
    then
        oc create -f ${RQ_FILE} -n ${OCP_PROJECT_NAME}
        oc label systemid=${SYSTEM_NAME} -f ${RQ_FILE} -n ${OCP_PROJECT_NAME}
    fi
done

set +ex