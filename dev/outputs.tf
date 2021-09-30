output "openvpn-ec2_instance_dns" {
  value = module.openvpn.public_dns
}

output "openvpn-url" {
  value = "https://${module.openvpn.public_dns}:943"
}

output "mssql-ec2_instance_dns" {
  value = module.ec2_instance_mssql.private_dns
}

output "ec2_instance_kafka_connect_schema-ec2_instance_dns" {
  value = module.ec2_instance_kafka_connect_schema.private_dns
}

output "bootstrap_brokers_scram" {
  description = "Connection host:port pairs"
  value       = aws_msk_cluster.msk.bootstrap_brokers_sasl_scram
}

output "mongo-ec2_instance_dns" {
  value = module.ec2_instance_mongodb.private_dns
}