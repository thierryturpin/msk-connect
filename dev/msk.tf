resource "aws_security_group" "sg_msk_private" {
  name        = "sg_msk_private"
  description = "msk-private"
  vpc_id      = module.vpc_dev.vpc_id
}

module "sg_msk_private_kafka_rule" {
  source            = "terraform-aws-modules/security-group/aws"
  create_sg         = false
  security_group_id = aws_security_group.sg_msk_private.id
  egress_rules      = ["all-all"]
  computed_ingress_with_source_security_group_id = [
    {
      from_port                = 9096
      to_port                  = 9096
      protocol                 = "tcp"
      source_security_group_id = module.sg_openvpn_private.security_group_id
    },
    {
      from_port                = 9096
      to_port                  = 9096
      protocol                 = "tcp"
      source_security_group_id = module.sg_mssql_private.security_group_id
    },
    {
      from_port                = 9096
      to_port                  = 9096
      protocol                 = "tcp"
      source_security_group_id = module.sg_mongodb_private.security_group_id
    },
  ]
  number_of_computed_ingress_with_source_security_group_id = 3
}

resource "aws_msk_cluster" "msk" {
  cluster_name           = "${var.env}-msk"
  kafka_version          = "2.6.2"
  number_of_broker_nodes = 2

  broker_node_group_info {
    instance_type   = "kafka.t3.small"
    ebs_volume_size = 50
    client_subnets  = module.vpc_dev.private_subnets
    security_groups = [aws_security_group.sg_msk_private.id]
  }
  client_authentication {
    sasl {
      scram = true
    }
  }
}

output "zookeeper_connect_string" {
  value = aws_msk_cluster.msk.zookeeper_connect_string
}

output "bootstrap_brokers_scram" {
  description = "Connection host:port pairs"
  value       = aws_msk_cluster.msk.bootstrap_brokers_sasl_scram
}

resource "aws_msk_scram_secret_association" "connect" {
  cluster_arn     = aws_msk_cluster.msk.arn
  secret_arn_list = [aws_secretsmanager_secret.connect.arn]

  depends_on = [aws_secretsmanager_secret_version.connect]
}

resource "aws_secretsmanager_secret" "connect" {
  name       = "AmazonMSK_connect-${var.connect_key}"
  kms_key_id = aws_kms_key.connect.key_id
}

resource "aws_kms_key" "connect" {
  description             = "Connect user key for MSK Cluster Scram Secret association ${var.connect_key}"
  deletion_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "connect" {
  secret_id     = aws_secretsmanager_secret.connect.id
  secret_string = jsonencode({ username = "user", password = "pass" })
}

resource "aws_secretsmanager_secret_policy" "example" {
  secret_arn = aws_secretsmanager_secret.connect.arn
  policy     = <<POLICY
{
  "Version" : "2012-10-17",
  "Statement" : [ {
    "Sid": "AWSKafkaResourcePolicy",
    "Effect" : "Allow",
    "Principal" : {
      "Service" : "kafka.amazonaws.com"
    },
    "Action" : "secretsmanager:getSecretValue",
    "Resource" : "${aws_secretsmanager_secret.connect.arn}"
  } ]
}
POLICY
}

