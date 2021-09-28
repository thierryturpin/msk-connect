# msk-connect

Important terraform variable: `my_public_ip`

## pre-requisites
* having an ssh key pair in the region

## openvpn server
* first connect with `root` user after that use `openvpnas`
* accept all defaults
* set password for webUI
* in the webUI set DNS client settings to vpc dns: `172.31.0.2` and update running server
```
ssh root@{public_ip} -i PEM/turpin.be.pem

sudo passwd openvpn
```
mgp4VbZVHwSPyYW3tm2xZi6WgWdSJgeaD

## setup mssql, mongodb and kcat
```
git clone https://thierryturpin@github.com/thierryturpin/msk-connect.git
```

* mongodb, copy template files from `credentials` dir
* mssql, set password in `.env` file and source `.env` file

mssql doesn't take a file like mongodb to source credentials, work-around, use docker secrets in a second step: https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-linux-ver15&preserve-view=true&pivots=cs1-bash#sapassword

## todo next steps:
* generate random secret https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password
* EC2 with docker for schema registry and connect


## Config file for kcat 
filename: `~/.config/kcat.conf`
```
security.protocol=SASL_SSL
sasl.mechanisms=SCRAM-SHA-512
api.version.request=true
sasl.username=user
sasl.password=
bootstrap.servers=b-1.dev-msk.w1o0en.c1.kafka.eu-west-1.amazonaws.com:9096,b-2.dev-msk.w1o0en.c1.kafka.eu-west-1.amazonaws.com:9096
```
