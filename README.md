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
9X7Us6uxhPGPFNNugftaYRbgU5HYrcvRC

## setup mssql, mongodb, kafkacat
```
git clone https://thierryturpin@github.com/thierryturpin/msk-connect.git
```

* mongodb, copy template files from `credentials` dir
* msslq, set passward in `.env` file and source `.env` file

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
sasl.password=pass
bootstrap.servers=b-1.dev-msk.w1o0en.c1.kafka.eu-west-1.amazonaws.com:9096,b-2.dev-msk.w1o0en.c1.kafka.eu-west-1.amazonaws.com:9096
```
