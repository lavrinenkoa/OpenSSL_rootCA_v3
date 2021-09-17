#!/bin/sh

if ! [ $# -eq 1 ]
then
    echo "Error: Incorrect usage."
    echo "Usage: $0 [Certificate public key]";
    exit 1
fi

NAME=$1

# Revoke certificate
## Name of PEM file
openssl ca \
    -config root-ca.conf \
    -revoke $NAME \
    -crl_reason keyCompromise

if ! [ $? -eq 0 ]
then
  echo "Error: Can not revoke $NAME certificate"
  exit 2
fi

# Create CRL
openssl ca -gencrl \
    -config root-ca.conf \
    -out root-ca/crl/root.crl

if ! [ $? -eq 0 ]
then
  echo "Error: Can not create CRL"
  exit 2
fi

exit 0

# Restart OCSP
# ToDo: Make correct return code
#systemctl restart ocsp
#if ! [ $? -eq 0 ]
#then
#  echo "Error: Can restart OCSP server"
#  exit 0
#fi

# Show CRL
echo "---------------- CRL -----------------"
openssl crl -inform PEM -text -noout -in root-ca/crl/root.crl
echo "--------------------------------------"

## Create DER CRL
#openssl crl \
#    -in crl/ca.crl \
#    -out crl/ca.crl.der \
#    -outform der

# Show CRL
#openssl crl -inform DER -text -noout -in crl/ca.crl.der
