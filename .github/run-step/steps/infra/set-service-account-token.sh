#!/usr/bin/bash

set -ex

oc version
helm version
jq --version

oc login --insecure-skip-tls-verify -u ${OCP_USER} -p ${OCP_CREDS} ${OCP_URL}

ENV_ARRAY=$(echo "${DEV_ENVIRONMENT} $(echo ${TEST_ENVIRONMENTS} | jq -jr  '" " + .[]')" | xargs)
echo "ENV_ARRAY: ${ENV_ARRAY}"
SERVICE_ACCOUNT_SECRET_PREFIX=${SYSTEM_NAME}-${TEAM_NAME}-service-account-token
for ENV in ${ENV_ARRAY}
do
    OCP_PROJECT_NAME="${SYSTEM_NAME}-${TEAM_NAME}-${ENV}"

    SA_SECRET_NAME=$(oc get secrets -o custom-columns=:.metadata.name -n ${OCP_PROJECT_NAME} | grep -m 1 ${SERVICE_ACCOUNT_SECRET_PREFIX})
    set +x
    SA_TOKEN="$(oc get secrets ${SA_SECRET_NAME} -o custom-columns=:.data.token -n ${OCP_PROJECT_NAME} | tr -d '[:space:]')"
    SA_TOKEN_DECODE="$(echo ${SA_TOKEN} | base64 -d)"
    set -x

    UPPERCASE_ENV=$(echo ${ENV} | tr '[:lower:]' '[:upper:]')
    (cd ${WORKING_DIR}; gh secret set OCP_SA_${UPPERCASE_ENV}_TOKEN --body "${SA_TOKEN_DECODE}")
done

set +ex
