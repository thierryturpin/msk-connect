# msk-connect

Important terraform variable: `my_public_ip`

## pre-requisites
* having an ssh key pair in the region

## ssh to openvpn server
* first connect with `root` user after that use `openvpnas`
* accept all defaults
* set password for webUI
* in the webUI set DNS client settings to vpc dns: `172.31.0.2` and update running server
```
ssh root@{public_ip} -i PEM/turpin.be.pem

sudo passwd openvpn
```
9X7Us6uxhPGPFNNugftaYRbgU5HYrcvRC


todo next steps:
* generate random secret https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password
* check to use Kafkacat
* source credentials from `.env` files with docker-compose
* EC2 with docker for schema registry and connect
* EC2 with docker for mongodb


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

```
git clone https://thierryturpin@github.com/thierryturpin/msk-connect.git
```
