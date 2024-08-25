#!/bin/bash

GERRIT_URL="gerrit.xxxx.com"
GERRIT_CHANGE_NUMBERS=
TEMP_FILE=/tmp/.gerrit_query_temp
JIRA_ID=$1

if [ -n ${JIRA_ID} ]; then
	echo "Quering open patchsets about JIRA [${JIRA_ID}]"
	echo "-----------------------------------------------------------"
	ssh -p 29418 ${GERRIT_URL} gerrit query --format=JSON status:open --commit-message="${JIRA_ID}"| grep -v runTimeMilliseconds > ${TEMP_FILE}
else
	echo "Quering open patchsets for ${OWNER}"
	ssh -p 29418 ${GERRIT_URL} gerrit query --format=JSON status:open | grep -v runTimeMilliseconds > tmp.txt
fi

while read -r GERRIT_CHANGE
do
	GERRIT_CHANGE_NUMBER=`echo "${GERRIT_CHANGE}" | jq ".number"`
	GERRIT_SUBJECT=`echo "${GERRIT_CHANGE}" | jq ".subject"`
	echo "${GERRIT_CHANGE_NUMBER}: ${GERRIT_SUBJECT}"
	GERRIT_CHANGE_NUMBERS="${GERRIT_CHANGE_NUMBER} ${GERRIT_CHANGE_NUMBERS}"
done < ${TEMP_FILE}
echo "-----------------------------------------------------------"
if [ -e ${TEMP_FILE} ]; then
	rm -r ${TEMP_FILE}
fi

GERRIT_CHANGES=""
for GERRIT_CHANGE_NUMBER in ${GERRIT_CHANGE_NUMBERS}
do
	GERRIT_PATCHSET_NUMBER=$(ssh -p 29418 ${GERRIT_URL} gerrit query --current-patch-set change:${GERRIT_CHANGE_NUMBER} | grep refs/ | awk -F ': ' '{print $NF}' | awk -F '/' '{print $NF}')
	if [ ${GERRIT_PATCHSET_NUMBER} = "1" ]; then
		GERRIT_CHANGE="${GERRIT_CHANGE_NUMBER} ${GERRIT_CHANGE}"
	else
		GERRIT_CHANGE="${GERRIT_CHANGE_NUMBER}/${GERRIT_PATCHSET_NUMBER} ${GERRIT_CHANGE}"
	fi
done
echo "Patch Build Args: ${GERRIT_CHANGE}"