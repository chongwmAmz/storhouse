#!/bin/bash
# Adapted from https://github.com/AlfrescoLabs/alfresco-opensearch-aws/blob/main/scripts/5-build-truststore.sh
set -o errexit
set -o pipefail
set -o nounset

if [ $# -lt 2 ]
  then
    echo "Server DNS name, port and storePass are expected as parameters, <serverDnsName>:<port> <storePass> Eg 'abc.mq.us-east-1.amazonaws.com:8162 secretOnlyIKnow'"
    exit 1
fi

TARGET_HOST=$1
STORE_PASS=$2

sudo amazon-linux-extras install -y java-openjdk11

mkdir -p truststore/certificates

cd truststore && cd certificates

openssl s_client -showcerts -verify 5 -connect ${TARGET_HOST} < /dev/null |
   awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/{ if(/BEGIN CERTIFICATE/){a++}; out="cert"a".pem"; print >out}'
for cert in *.pem; do
        newname=$(openssl x509 -noout -subject -in $cert | sed -nE 's/.*CN ?= ?(.*)/\1/; s/[ ,.*]/_/g; s/__/_/g; s/_-_/-/; s/^_//g;p' | tr '[:upper:]' '[:lower:]').pem
        echo "${newname}"; mv "${cert}" "${newname}"
done

# Since Java doesn't accept default PKCS12 truststores produced with OpenSSL, using keytool is required
for cert in *.pem; do
    keytool -import -alias ${cert} -noprompt -file ${cert} -keystore ../truststore.pkcs12 -storetype PKCS12 -storepass ${STORE_PASS}
done


echo "-----------------------------------------"
echo "Generated output file truststore/truststore.pkcs12 file with password ${STORE_PASS}"
