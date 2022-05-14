#!/usr/bin/bash

ENV_ARRAY=$(echo "${DEV_ENVIRONMENT} $(echo ${TEST_ENVIRONMENTS} | jq -jr  '" " + .[]')" | xargs)
echo "ENV_ARRAY: ${ENV_ARRAY}"
for ENV in ${ENV_ARRAY}
do
    if [[ ${DEPLOY_ENV} != ${ENV} ]]
    then
        PREVIOUS_ENVIRONMENT=${ENV}
    else
        break
    fi
done

skopeo --src-tls-verify=false --dest-tls-verify=false \
        --src-creds ${user}:\${${fromTokenVar}} --dest-creds ${user}:\${${fromTokenVar}} \
         ${IMAGE_REGISTRY_URL}/${IMAGE_REGISTRY_USERNAME}/${IMAGE_NAME}:${PREVIOUS_ENVIRONMENT} \
         ${IMAGE_REGISTRY_URL}/${IMAGE_REGISTRY_USERNAME}/${IMAGE_NAME}:${DEPLOY_ENV}