##========================================================================================
##                                                                                      ##
##                                          EC2                                         ##
##                                                                                      ##
##========================================================================================

module "sg_mongodb_private" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = "sg_mongodb_private"
  description = "mongodb-private"
  vpc_id      = module.vpc_dev.vpc_id

}

module "sg_mongodb_private_rules" {
  source            = "terraform-aws-modules/security-group/aws"
  create_sg         = false
  security_group_id = module.sg_mongodb_private.security_group_id
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
      rule                     = "mongodb-27017-tcp"
      source_security_group_id = module.sg_openvpn_private.security_group_id
    },
    {
      rule                     = "mongodb-27017-tcp"
      source_security_group_id = module.sg_kafka_connect_schema_private.security_group_id
    },
  ]

  number_of_computed_ingress_with_source_security_group_id = 3
}

module "ec2_instance_mongodb" {
  source = "terraform-aws-modules/ec2-instance/aws"
  name   = "${var.env}-docker-mongodb"

  ami = data.aws_ami.amazon_linux-2.id

  # iam_instance_profile = "" todo
  source_dest_check           = true
  instance_type               = "t2.small"
  vpc_security_group_ids      = [module.sg_mongodb_private.security_group_id]
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