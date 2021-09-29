```
export connect_host="172.31.59.134"
```

for mssql update:
* database hostname
* bootstrap server
* jass config with connect user and password


for mongodb update:
* the connect uri

```
# List installed connectors
curl http://$connect_host:28082/connector-plugins | jq

# list tasks and state
curl http://$connect_host:28082/connectors/ | jq

# Get tasks details
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

