```
export connect_host="172.31.59.134"
```

```
# List installed connectors
curl http://$connect_host:28082/connector-plugins | jq

# list tasks and state
curl http://$connect_host:28082/connectors/ | jq

# Get tasks details
export task=mssql-dbo-orders

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

curl -i -X POST \
    -H "Accept:application/json" \
    -H "Content-Type:application/json" http://$connect_host:28082/connectors/ -d @$taskjson

```



