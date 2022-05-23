#!/usr/bin/bash

podman build --squash -t ${IMAGE_REGISTRY_URL}/${IMAGE_REGISTRY_USERNAME}/${IMAGE_NAME}:${DEV_ENVIRONMENT} -f ${WORKING_DIR}/Dockerfile