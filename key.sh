#!/bin/sh

check_status() {
    if [ $? -eq 0 ]; then
        echo "Success: $1"
    else
        echo "Failure: $1"
        exit 1
    fi
}

export ORG_NAME="Domnic-Raj"
#export GITHUB_TOKEN="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"
export GITHUB_TOKEN="$GH_TKN"
#export secret=$sec
#echo "secret=$sec">> env_vars.sh

#export azcity="Trichy"
#export azemail="test@example.com"
#export azname="Domnic Raj - Secret"
#export azage="18"

#env | grep '^az' > envsystem
echo "$json"
if ! echo ${json} | jq empty; then
   echo "Error: Invalid JSON string provided."
   exit 1
 else
   echo "valid JSON"
   echo "${json}"
fi

echo ${json} | jq -r 'keys[]' | while IFS= read -r e; do
key="${e}"
value=$(echo ${json}| jq -r ".${key}")
echo "${key}=${value}"
#echo " Environment name : $key"
#secretname=$(echo $sec | awk -F'=' '{print$1}'| sed 's/^az//')
secretname="${e}"
echo " secret name = ${e}"
#export secret="$(echo $sec | awk -F'=' '{print$2}')"
export secret=$(echo ${json}| jq -r ".${key}")
echo " value = $secret "

while read line; do
echo " Repo Name = $line"
echo " value = $secret "
echo " secret name = $secretname "
API_URL="https://api.github.com/repos/$ORG_NAME/$line/actions/secrets/public-key"
API_URL1="https://api.github.com/repos/$ORG_NAME/$line/actions/secrets/$secretname"
RESPONSE=$(curl -L -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $GITHUB_TOKEN" -H "X-GitHub-Api-Version: 2022-11-28" "$API_URL")
check_status "Getting public key for $line"
#echo " $RESPONSE"
key_id=$(echo "$RESPONSE" | jq -r '.key_id')
export key=$(echo "$RESPONSE" | jq -r '.key')
#echo "key_id=$(echo "$RESPONSE" | jq -r '.key_id')"
#echo "key=$(echo "$RESPONSE" | jq -r '.key')" >> env_vars.sh
#. ./env_vars.sh
echo " key=$key"
echo "secret=$secret"
python3 libsodium.py
check_status "Running Python script for $line"
#. ./env_vars1.sh
. ./env_vars.sh
#INPUT="-d '{"encrypted_value":"$encrypted_secret","key_id":"$key_id"}'"
INPUT='-d '{\"encrypted_value\":\"$encrypted_secret\",\"key_id\":\"$key_id\"}''
#echo " $INPUT"
RESPONSE1=$(curl -sSL -X PUT -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $GITHUB_TOKEN" -H "X-GitHub-Api-Version: 2022-11-28" "$API_URL1" "${INPUT}")
check_status "Updating secret for $line"
echo "----------------------------------------------------------------"
done < inv.txt
done
