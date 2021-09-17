#!/bin/sh
if ! [ $# -eq 1 ]
then
    echo "Error: Incorrect usage."
    echo "Usage: $0 [Certificate .pem file]";
    exit 1
fi

openssl ocsp -issuer ./root-ca/certs/ca.crt \
             -trust_other \
             -verify_other ./root-ca/certs/ca.crt \
             -CAfile ./root-ca/certs/ca.crt \
             -url http://localhost:7777 \
             -text \
             -cert $1
#             -serial $1 \
