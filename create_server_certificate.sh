#!/bin/sh

if ! [ $# -eq 2 ]
then
    echo "Error: Incorrect usage."
    echo "Usage: $0 [Certificate CommonName] [days]";
    exit 1
fi

NAME=$1
DAYS=$2
DNS=DNS:$NAME.us
#DNS=DNS:int_server.us

## Create SERVER elliptic curve parameters:
#EC=secp256r1
#EC_PARAMS=certs/ec-$EC.pem
#openssl ecparam -out $EC_PARAMS -name $EC

# Generate CA key
openssl genrsa \
        -out certs/$NAME.key 2048

# Generate certificate request
openssl req \
        -config server.conf \
        -sha256 \
        -new \
        -key certs/$NAME.key \
        -out certs/$NAME.csr \
        -subj "/CN=$NAME/O=Server/C=US"        

# Create TLS server request
# rm -f certs/$NAME.csr certs/$NAME.key
# SAN=$DNS \
# openssl req \
#      -new \
#     -config etc/server.conf \
#     -newkey ec:$EC_PARAMS \
#     -out certs/$NAME.csr \
#     -keyout certs/$NAME.key \
#     -subj "/CN=$NAME/O=Server/C=US"

if ! [ -s certs/$NAME.csr ]
then
  echo "Error: Can not create certificate request file"
  exit 2
fi

# Sign KMS cert
openssl ca \
        -batch \
        -config root-ca.conf \
        -keyfile root-ca/private/ca.key \
        -cert root-ca/certs/ca.crt \
        -extensions v3_req \
        -notext \
        -md sha256 \
        -in certs/$NAME.csr \
        -out  certs/$NAME.crt \
        -extensions server_ext \
        -days $DAYS
    
# Create TLS server certificate
# rm -f certs/$NAME.crt
# openssl ca \
#     -batch\
#     -config etc/ca.conf \
#     -in certs/$NAME.csr \
#     -out certs/$NAME.crt \
#     -extensions server_ext \
#     -days $DAYS

# -startdate 120815080000Z -enddate 120815090000Z -

# rm -f $EC_PARAMS

if ! [ -s certs/$NAME.crt ]
then
  echo "Error: Can not create TLS server certificate file"
  exit 3
fi

exit 0
