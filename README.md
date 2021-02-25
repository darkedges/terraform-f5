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
