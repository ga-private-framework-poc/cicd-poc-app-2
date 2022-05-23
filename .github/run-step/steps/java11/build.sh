#!/usr/bin/bash

export JAVA_TOOL_OPTIONS=
if [[ -f $(dirname ${0})/settings.xml ]]
then
    mvn -s $(dirname ${0})/settings.xml -DskipTests --batch-mode -f ${WORKING_DIR} clean package
else
    mvn -DskipTests --batch-mode -f ${WORKING_DIR} clean package
fi