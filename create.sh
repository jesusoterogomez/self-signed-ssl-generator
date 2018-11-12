#!/usr/bin/env bash

# Create SSL / TEMP directory
mkdir ssl
mkdir temp

source "server.conf"

# Create CSR Configuration
cat <<EOF > ./temp/server.csr.cnf
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn

[dn]
C=$CERT_COUNTRY
ST=$CERT_STATE
OU=$CERT_ORGANIZATION
emailAddress=$CERT_EMAIL
CN = $CERT_DOMAIN
EOF

# Create Extension Configuration
cat <<EOF > ./temp/v3.ext
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = $CERT_DOMAIN
EOF


# Generate Root CA Key
openssl genrsa -out ./ssl/rootCA.key 2048

# Generate Root CA Certificate
openssl req -x509 -new -nodes -key ./ssl/rootCA.key -sha256 -days 1024 -config ./temp/server.csr.cnf -out ./ssl/rootCA.pem

# Generate CSR
openssl req -new -sha256 -nodes -out ./ssl/server.csr -newkey rsa:2048 -keyout ./ssl/server.key -config ./temp/server.csr.cnf

# Create Certificate with v3 extension for Subject Alt Name
openssl x509 -req -in ./ssl/server.csr -CA ./ssl/rootCA.pem -CAkey ./ssl/rootCA.key -CAcreateserial -out ./ssl/server.crt -days 500 -sha256 -extfile ./temp/v3.ext
