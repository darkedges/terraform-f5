# Terraform F5 POC

## Deploy

```bash
export TF_VAR_F5_USERNAME=xxxxxx
export TF_VAR_F5_PASSWORD=xxxxxx
export TF_VAR_F5_ADDRESS=xxxxxx
terraform init
terraform plan
terraform apply
```

## Further Details

[https://confluence.asx.com.au/display/~irving_n/Terraform+-+F5+Virtual+Server](https://confluence.asx.com.au/display/~irving_n/Terraform+-+F5+Virtual+Server)

## Sample CURL Commands

### ForgeRock Identity Gateway

```bash
curl https://f5-ig.asx.idaas.xyz:8443/
```

### Pretend to a ForgeRock Identity Gateway

```bash
curl https://f5-idm.asx.idaas.xyz:9443/openidm/info/login\
    -k \
    --key .ssl/forgerock.key \
    --cert .ssl/forgerock.certificate \
    --header "X-OpenIDM-RunAs: asxadmin" -v | jq .
```

## create FRIG Keystore

### Linux

```bash
openssl.exe pkcs12 \
    -export \
    -in .ssl/forgerock.certificate \
    -inkey .ssl/forgerock.key \
    -out .ssl/forgerock.p12 \
    -name forgerock
```

```bash
keytool -importkeystore \
    -deststorepass Passw0rd \
    -destkeystore ./ssl/server.keystore \
    -srckeystore .ssl/server.p12 \
    -srcstoretype PKCS12 \
    -srcstorepass Passw0rd \
    -alias forgerock
```

### windows

```bash
openssl.exe pkcs12 -export -in .ssl\forgerock.certificate -inkey .ssl\forgerock.key -out .ssl\forgerock.p12 -name forgerock
```

```bash
keytool -importkeystore -deststorepass Passw0rd -destkeystore .ssl\fr-clientauth.jks -srckeystore .ssl\forgerock.p12 -srcstoretype PKCS12 -srcstorepass Passw0rd -alias forgerock
```


## Openssl

```bash
mkdir CertificateAuthCA
cd CertificateAuthCA
openssl genrsa -des3 -out myca.key 4096
openssl req -new -x509 -days 3650 -key myca.key -out myca.crt
openssl genrsa -des3 -out testuser.key 2048
openssl req -new -key testuser.key -out testuser.csr
openssl x509 -req -days 365 -in testuser.csr -CA myca.crt -CAkey myca.key -set_serial 01 -out testuser.crt
openssl pkcs12 -export -out testuser.pfx -inkey testuser.key -in testuser.crt -certfile myca.crt

openssl genrsa -des3 -out testuser-invalid.key 2048
openssl req -new -key testuser-invalid.key -out testuser-invalid.csr
openssl x509 -req -days 365 -in testuser-invalid.csr -CA myca.crt -CAkey myca.key -set_serial 02 -out testuser-invalid.crt
openssl pkcs12 -export -out testuser-invalid.pfx -inkey testuser-invalid.key -in testuser-invalid.crt -certfile myca.crt
```
