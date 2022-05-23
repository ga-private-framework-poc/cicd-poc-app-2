
#!/usr/bin/bash

set -ex

COMPONENT_NAME=$(basename ${WORKING_DIR})
echo "COMPONENT_NAME=${COMPONENT_NAME}" >> ${GITHUB_ENV}

HELM_CHART_DIR=${WORKING_DIR}/.helm
echo "HELM_CHART_DIR=${HELM_CHART_DIR}" >> ${GITHUB_ENV}

IMAGE_NAME=$(echo "${COMPONENT_NAME}" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]' | tr -c '[:alnum:]' '_' )
echo "IMAGE_NAME=${IMAGE_NAME}" >> ${GITHUB_ENV}

CODEBASE=$(yq ".components[] | select(.repo == \"${COMPONENT_NAME}\") | .codebase" ${SYSTEM_DEFS_FILE})
echo "CODEBASE=${CODEBASE}" >> ${GITHUB_ENV}

OVERRIDES=$(yq ".components[] | select(.repo == \"${COMPONENT_NAME}\") | .overrides" ${SYSTEM_DEFS_FILE})
echo "OVERRIDES=${OVERRIDES}" >> ${GITHUB_ENV}

set +ex