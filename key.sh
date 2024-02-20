#!/bin/sh
export ORG_NAME="Domnic-Raj"
#export GITHUB_TOKEN="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"
export GITHUB_TOKEN="$GH_TKN"
secret=$sec
while read line; do
API_URL="https://api.github.com/repos/$ORG_NAME/$line/actions/secrets/public-key"
API_URL1="https://api.github.com/repos/$ORG_NAME/$line/actions/secrets/put"
RESPONSE=$(curl -L -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $GITHUB_TOKEN" -H "X-GitHub-Api-Version: 2022-11-28" "$API_URL")
echo " $RESPONSE"
key_id=$(echo "$RESPONSE" | jq -r '.key_id')
key=$(echo "$RESPONSE" | jq -r '.key') > env_vars.sh
#echo "key_id=$(echo "$RESPONSE" | jq -r '.key_id')"
#echo "key=$(echo "$RESPONSE" | jq -r '.key')"
source ./env_vars.sh
python3 libsodium.py
source ./env_vars.sh
#INPUT="-d '{"encrypted_value":"$encrypted_secret","key_id":"$key_id"}'"
INPUT='-d '{\"encrypted_value\":\"$encrypted_secret\",\"key_id\":\"$key_id\"}''
echo " $INPUT"
RESPONSE1=$(curl -L -X PUT -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $GITHUB_TOKEN" -H "X-GitHub-Api-Version: 2022-11-28" "$API_URL1" "${INPUT}")
#echo "$RESPONSE1"
if $? -eq 0; then
echo " success"
else
echo "failed"
fi
done < inv.txt
