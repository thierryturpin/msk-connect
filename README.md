# msk-connect

YouTube [recording](https://youtu.be/g5Kb53irYrI)  

Important terraform variable: `my_public_ip`
```
curl ifconfig.me/all
```

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

## setup mssql, mongodb and kcat
```
git clone https://thierryturpin@github.com/thierryturpin/msk-connect.git
bw get password docker-build-push | pbcopy
```

* mongodb, copy template files from `credentials` dir
* mssql, set password in `.env` file and source `.env` file
* kafka connect, update .env file with broker, jaas_config and connect credentials

mssql doesn't take a file like mongodb to source credentials, work-around, use docker secrets in a second step: https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-linux-ver15&preserve-view=true&pivots=cs1-bash#sapassword

## Config file for kcat 
filename: `~/.config/kcat.conf`
```
security.protocol=SASL_SSL
sasl.mechanisms=SCRAM-SHA-512
api.version.request=true
sasl.username=connect
sasl.password=
bootstrap.servers=b-1.dev-msk.w1o0en.c1.kafka.eu-west-1.amazonaws.com:9096,b-2.dev-msk.w1o0en.c1.kafka.eu-west-1.amazonaws.com:9096
```

kcat consume data
```
kcat -t dev.dbo.ORDERS -s avro -r http://172.31.63.42:8081
```

# Kafka connect REST interface interactions
```
export connect_host="172.31.59.134"
```

for `mssql-dbo-orders.json` update:
* database hostname
* bootstrap server
* jass config with connect user and password


for `mongo-dbo-orders.json` update:
* the connect uri

```
# List installed connectors
curl http://$connect_host:28082/connector-plugins | jq

# list tasks and state
curl http://$connect_host:28082/connectors/ | jq

# Get tasks details
cd /Users/thierryturpin/PycharmProjects/msk-connect/kafka-connect-schema
export task=mssql-dbo-orders
export task=mongodb-dbo-orders

# status
curl http://$connect_host:28082/connectors/$task/status | jq

# defintion posted
curl http://$connect_host:28082/connectors/$task/tasks | jq

# delete a task
curl -i -X DELETE \
    -H "Accept:application/json" \
    -H  "Content-Type:application/json" \
    http://$connect_host:28082/connectors/$task/

# create a task
export taskjson=mssql-dbo-orders.json
export taskjson=mongodb-dbo-orders.json

curl -i -X POST \
    -H "Accept:application/json" \
    -H "Content-Type:application/json" http://$connect_host:28082/connectors/ -d @$taskjson

```
Kafka connect rest interface [doc](https://docs.confluent.io/4.1.0/connect/references/restapi.html)

