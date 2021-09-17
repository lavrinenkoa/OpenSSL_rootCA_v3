#!/bin/bash -x

set -e

C=ca

mkdir $C
cd $C
mkdir certs crl newcerts private
cd ..

echo 1000 > $C/serial
touch $C/index.txt $C/index.txt.attr

# Generate CA key
openssl genrsa \
        -out ca/private/ca.key 2048

# Generate certificate request
openssl req \
        -config ca.conf \
        -sha256 \
        -new \
        -key ca/private/ca.key \
        -out ca/certs/ca.csr \
        -subj '/CN=CA'

# Sign cert
openssl ca \
        -batch \
        -config root-ca.conf \
        -keyfile root-ca/private/ca.key \
        -cert root-ca/certs/ca.crt \
        -extensions v3_req \
        -notext \
        -md sha256 \
        -in ca/certs/ca.csr \
        -out ca/certs/ca.crt

cp ca/certs/ca.crt certs/
cp ca/private/ca.key certs/
cat certs/ca.crt >> certs/chain.pem
cat certs/ca.crt >> certs/chain.pem
mkdir crl
