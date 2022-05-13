#!/usr/bin/bash

set -ex

cp -RT ${CICD_REPO_MGR_DIR}/.github ${WORKING_DIR}/.github

echo 'Generating .github directory for ${REPO_NAME}'

rm ${WORKING_DIR}/.github/workflows/onboard-system.*

for F_NAME in $(find ${WORKING_DIR}/.github/workflows -name "*.template")
do
    mv ${F_NAME} $(echo ${F_NAME} | sed -e "s/.template$//") ;
done

find ${WORKING_DIR}/.github/workflows/ -type f \( -iname \*.yml -o -iname \*.yaml \) \
    -exec sed -i -e "s/%SYSTEM_NAME%/${SYSTEM_NAME}/g" \
                 -e "s/%TEAM_NAME%/${TEAM_NAME}/g" \
                 -e "s/%DEV_BRANCH%/${DEV_BRANCH}/g" \
                 -e "s|%REPO_NAME%|${REPO_NAME}|g" {} +


git -C ${WORKING_DIR} add -u
if [[ ! -z "$(git -C ${WORKING_DIR} status --porcelain)" ]]
then
    git -C ${WORKING_DIR} config user.email ${cicd-team@my-org.com}
    git -C ${WORKING_DIR} config user.name ${GITHUB_ACTOR}
    git -C ${WORKING_DIR} add -A
    git -C ${WORKING_DIR} commit -am '[skip ci] installing latest cicd-manager GitHub Action Workflow(s)'
    git -C ${WORKING_DIR} push
    echo "Pushed ${WORKING_DIR}/.github to ${REPO_NAME}"
else
    echo "${REPO_NAME} is unchanged.  Skipping..."
fi

set +ex