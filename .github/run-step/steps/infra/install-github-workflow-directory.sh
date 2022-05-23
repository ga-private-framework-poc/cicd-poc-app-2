#!/usr/bin/bash

set -ex

[ $(find ${WORKING_DIR}/.github/workflows -name "*.build.yml" -print -quit | wc -l) -gt 0 ] && cp -v *.build.yml /tmp
git -C ${WORKING_DIR} rm -rf .github || :
cp -RT ${CICD_REPO_MGR_DIR}/.github ${WORKING_DIR}/.github
[ $(find /tmp -name "*.build.yml" -print -quit | wc -l) -gt 0 ] && cp -v /tmp/*.build.yml ${WORKING_DIR}/.github/workflows/

echo 'Generating .github directory for ${REPO_NAME}'

for F_NAME in $(find ${WORKING_DIR}/.github/workflows -name "*.template")
do
    mv ${F_NAME} $(echo ${F_NAME} | sed -e "s/.template$//") ;
done

rm ${WORKING_DIR}/.github/workflows/onboard*.* 
mv ${WORKING_DIR}/.github/workflows/build.yml ${WORKING_DIR}/.github/workflows/${SYSTEM_NAME}-${TEAM_NAME}.build.yml

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