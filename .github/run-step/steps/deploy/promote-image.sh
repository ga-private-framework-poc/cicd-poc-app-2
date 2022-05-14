#!/usr/bin/bash

set -ex

ENV_ARRAY=$(echo "$(echo ${NON_PROD_ENVIRONMENTS} | jq -jr  '" " + .[]')" | xargs)
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

skopeo copy --src-tls-verify=false --dest-tls-verify=false \
       --src-creds ${IMAGE_REGISTRY_USERNAME}:${IMAGE_REGISTRY_PWD} --dest-creds ${IMAGE_REGISTRY_USERNAME}:${IMAGE_REGISTRY_PWD} \
       docker://${IMAGE_REGISTRY_URL}/${IMAGE_REGISTRY_USERNAME}/${IMAGE_NAME}:${PREVIOUS_ENVIRONMENT} \
       docker://${IMAGE_REGISTRY_URL}/${IMAGE_REGISTRY_USERNAME}/${IMAGE_NAME}:${DEPLOY_ENV}


set +ex