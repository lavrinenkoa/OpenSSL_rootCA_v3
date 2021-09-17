#!/bin/bash -x


cert=$1

# Generate KMS CA key
openssl genrsa \
        -out $cert.key 2048

# Generate certificate request
openssl req \
        -sha256 \
        -new \
        -key $cert.key \
        -out $cert.csr \
        -subj "/CN=$cert"

# Sign KMS cert
openssl ca \
        -batch \
        -config root-ca.conf \
        -keyfile root-ca/private/ca.key \
        -cert root-ca/certs/ca.crt \
        -extensions v3_req \
        -notext \
        -md sha256 \
        -in $cert.csr \
        -out $cert.crt
