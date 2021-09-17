#!/bin/bash -x

set -e

C=root-ca

mkdir $C
cd $C
mkdir certs crl newcerts private
cd ..

echo 1000 > $C/serial
touch $C/index.txt $C/index.txt.attr

# Generate self-sigened root-ca certificate
openssl genrsa \
        -out root-ca/private/ca.key 2048
openssl req \
        -config root-ca.conf \
        -new \
        -x509 \
        -days 3650 \
        -key root-ca/private/ca.key \
        -sha256 \
        -out root-ca/certs/ca.crt \
        -subj '/CN=Root CA' \
        -extensions v3_req \

openssl ca -gencrl -config root-ca.conf -out root-ca/crl/root.crl

mkdir certs
cp root-ca/certs/ca.crt certs/

