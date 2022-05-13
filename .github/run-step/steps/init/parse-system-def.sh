
#!/usr/bin/bash

set -ex

OCP_URL=$(yq '.cluster-url' ${SYSTEM_CONFIG_FILE})
echo "OCP_URL=${OCP_URL}" >> ${GITHUB_ENV}

IMAGE_REGISTRY_URL=$(yq '.image-registry.url' ${SYSTEM_CONFIG_FILE})
echo "IMAGE_REGISTRY_URL=${IMAGE_REGISTRY_URL}" >> ${GITHUB_ENV}

IMAGE_REGISTRY_USERNAME=$(yq '.image-registry.username' ${SYSTEM_CONFIG_FILE})
echo "IMAGE_REGISTRY_USERNAME=${IMAGE_REGISTRY_USERNAME}" >> ${GITHUB_ENV}

SYSTEM_DEFS_FILE=$(ls ${SYSTEM_DEFS_DIR}/${SYSTEM_NAME}.y*)
echo "SYSTEM_DEFS_FILE=${SYSTEM_DEFS_FILE}" >> ${GITHUB_ENV}

TEAM_NAME=$(yq '.team' "${SYSTEM_DEFS_FILE}")
echo "TEAM_NAME=${TEAM_NAME}" >> ${GITHUB_ENV}

DEV_BRANCH=$(yq '.branch' "${SYSTEM_DEFS_FILE}")
echo "DEV_BRANCH=${DEV_BRANCH}" >> ${GITHUB_ENV}

REPO_NAMES=$(yq '[env(GITHUB_REPOSITORY_OWNER) + "/" + .components[].repo]' "${SYSTEM_DEFS_FILE}" -o json -I=0)
echo "REPO_NAMES=${REPO_NAMES}" >> ${GITHUB_ENV}

DEV_ENVIRONMENT=$(yq '.dev-environment' "${SYSTEM_DEFS_FILE}")
echo "DEV_ENVIRONMENT=${DEV_ENVIRONMENT}" >> ${GITHUB_ENV}

TEST_ENVIRONMENTS=$(yq '.test-environments' "${SYSTEM_DEFS_FILE}" -o json -I=0)
echo "TEST_ENVIRONMENTS=${TEST_ENVIRONMENTS}" >> ${GITHUB_ENV}

NON_PROD_ENVIRONMENTS=$(yq '[.dev-environment] + .test-environments' "${SYSTEM_DEFS_FILE}" -o json -I=0)
echo "NON_PROD_ENVIRONMENTS=${NON_PROD_ENVIRONMENTS}" >> ${GITHUB_ENV}

RESOURCE_QUOTAS=$(yq '.resource-quotas' "${SYSTEM_DEFS_FILE}" -o json -I=0)
echo "RESOURCE_QUOTAS=${RESOURCE_QUOTAS}" >> ${GITHUB_ENV}

set +ex