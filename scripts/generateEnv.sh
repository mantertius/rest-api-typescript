#!/usr/bin/env bash

#
# SPDX-License-Identifier: Apache-2.0
#

${AS_LOCAL_HOST:=true}

: "${TEST_NETWORK_HOME:=/home/elvys/go/src/github.com/elvyssoares/fabric-samples/test-network}"
: "${CONNECTION_PROFILE_FILE_ORG1:=${TEST_NETWORK_HOME}/organizations/peerOrganizations/org1.example.com/connection-org1.json}"
: "${CERTIFICATE_FILE_ORG1:=${TEST_NETWORK_HOME}/organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/signcerts/cert.pem}"
: "${PRIVATE_KEY_FILE_ORG1:=${TEST_NETWORK_HOME}/organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/keystore/0bf1e45ca86e239484b126c38a64e68c82eb5134ef5f5b56c442d353af59a474_sk}"

: "${CONNECTION_PROFILE_FILE_ORG2:=${TEST_NETWORK_HOME}/organizations/peerOrganizations/org2.example.com/connection-org2.json}"
: "${CERTIFICATE_FILE_ORG2:=${TEST_NETWORK_HOME}/organizations/peerOrganizations/org2.example.com/users/User1@org2.example.com/msp/signcerts/cert.pem}"
: "${PRIVATE_KEY_FILE_ORG2:=${TEST_NETWORK_HOME}/organizations/peerOrganizations/org2.example.com/users/User1@org2.example.com/msp/keystore/c8c372da4dcf5e6d08309d23856d79afe813c1638af927305b045103abee20e0_sk}"


cat << ENV_END > .env
# Generated .env file
# See src/config.ts for details of all the available configuration variables
#

LOG_LEVEL=info

PORT=3000

HLF_CERTIFICATE_ORG1="$(cat ${CERTIFICATE_FILE_ORG1} | sed -e 's/$/\\n/' | tr -d '\r\n')"

HLF_PRIVATE_KEY_ORG1="$(cat ${PRIVATE_KEY_FILE_ORG1} | sed -e 's/$/\\n/' | tr -d '\r\n')"

HLF_CERTIFICATE_ORG2="$(cat ${CERTIFICATE_FILE_ORG2} | sed -e 's/$/\\n/' | tr -d '\r\n')"

HLF_PRIVATE_KEY_ORG2="$(cat ${PRIVATE_KEY_FILE_ORG2} | sed -e 's/$/\\n/' | tr -d '\r\n')"

REDIS_PORT=6379

ORG1_APIKEY=$(uuidgen)

ORG2_APIKEY=$(uuidgen)

ENV_END
 
if [ "${AS_LOCAL_HOST}" = "true" ]; then

cat << LOCAL_HOST_END >> .env
AS_LOCAL_HOST=true

HLF_CONNECTION_PROFILE_ORG1=$(cat ${CONNECTION_PROFILE_FILE_ORG1} | jq -c .)

HLF_CONNECTION_PROFILE_ORG2=$(cat ${CONNECTION_PROFILE_FILE_ORG2} | jq -c .)

REDIS_HOST=localhost

LOCAL_HOST_END

elif [ "${AS_LOCAL_HOST}" = "false" ]; then

cat << WITH_HOSTNAME_END >> .env
AS_LOCAL_HOST=false

HLF_CONNECTION_PROFILE_ORG1=$(cat ${CONNECTION_PROFILE_FILE_ORG1} | jq -c '.peers["peer0.org1.example.com"].url = "grpcs://peer0.org1.example.com:7051" | .certificateAuthorities["ca.org1.example.com"].url = "https://ca.org1.example.com:7054"')

HLF_CONNECTION_PROFILE_ORG2=$(cat ${CONNECTION_PROFILE_FILE_ORG2} | jq -c '.peers["peer0.org2.example.com"].url = "grpcs://peer0.org2.example.com:9051" | .certificateAuthorities["ca.org2.example.com"].url = "https://ca.org2.example.com:8054"')

REDIS_HOST=redis

WITH_HOSTNAME_END

fi
