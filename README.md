# msk-connect

Important terraform variable: `my_public_ip`

## ssh to openvpn server
* first connect with root user
* accept all defaults
* set password for webUI
* in the webUI set DNS client settings to vpc dns: `172.31.0.2` and update running server
```
ssh root@{public_ip} -i PEM/TT.pem

sudo passwd openvpn
```


9X7Us6uxhPGPFNNugftaYRbgU5HYrcvRC