#!/usr/bin/bash

export JAVA_TOOL_OPTIONS=
if [[ -f $(dirname ${0})/settings.xml ]]
then
    mvn -s $(dirname ${0})/settings.xml  -f ${WORKING_DIR} test
else
    mvn  -f ${WORKING_DIR} test
fi