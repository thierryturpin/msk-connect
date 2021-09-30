##========================================================================================
##                                                                                      ##
##                                          EC2                                         ##
##                                                                                      ##
##========================================================================================

module "sg_kafka_connect_schema_private" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = "sg_kafka_connect_schema_private"
  description = "kafka-connect-schema-private"
  vpc_id      = module.vpc_dev.vpc_id

}

module "sg_connect_schema_private_rule_openvpn" {
  source            = "terraform-aws-modules/security-group/aws"
  create_sg         = false
  security_group_id = module.sg_kafka_connect_schema_private.security_group_id
  egress_rules      = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      rule        = "all-icmp"
      cidr_blocks = join(",", var.private_subnets_cidrs)
    },
  ]
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "ssh-tcp"
      source_security_group_id = module.sg_openvpn_private.security_group_id
    },
    {
      from_port                = 8081
      to_port                  = 8081
      protocol                 = "tcp"
      source_security_group_id = module.sg_openvpn_private.security_group_id
    },
    {
      from_port                = 28082
      to_port                  = 28082
      protocol                 = "tcp"
      source_security_group_id = module.sg_openvpn_private.security_group_id
    },
  ]

  number_of_computed_ingress_with_source_security_group_id = 3
}

module "ec2_instance_kafka_connect_schema" {
  source = "terraform-aws-modules/ec2-instance/aws"
  name   = "${var.env}-docker-kafka-connect-schema"

  ami = data.aws_ami.amazon_linux-2.id

  # iam_instance_profile = "" todo
  source_dest_check           = true
  instance_type               = "t2.xlarge"
  vpc_security_group_ids      = [module.sg_kafka_connect_schema_private.security_group_id]
  associate_public_ip_address = false
  availability_zone           = element(module.vpc_dev.azs, 0)
  subnet_id                   = element(module.vpc_dev.private_subnets, 0)
  user_data_base64            = base64encode(local.user_data)
  key_name                    = var.ami_key_pair_name
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      volume_size = 50
    },
  ]
}