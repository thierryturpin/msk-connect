##========================================================================================
##                                                                                      ##
##                                          EC2                                         ##
##                                                                                      ##
##========================================================================================

module "sg_openvpn_public" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = "sg_openvpn_public"
  description = "openvpn-public"
  vpc_id      = module.vpc_dev.vpc_id
}

module "sg_openvpn_public_rule_openvpn" {
  source            = "terraform-aws-modules/security-group/aws"
  create_sg         = false
  security_group_id = module.sg_openvpn_public.security_group_id
  egress_rules      = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = var.my_public_ip
    },
    {
      rule        = "https-443-tcp"
      cidr_blocks = var.my_public_ip
    },
    {
      rule        = "openvpn-udp"
      cidr_blocks = var.my_public_ip
    },
    {
      rule        = "openvpn-tcp"
      cidr_blocks = var.my_public_ip
    },
  ]
}

module "sg_openvpn_private" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = "sg_openvpn_private"
  description = "openvpn-private"
  vpc_id      = module.vpc_dev.vpc_id

}

module "sg_openvpn_private_rule_openvpn" {
  source            = "terraform-aws-modules/security-group/aws"
  create_sg         = false
  security_group_id = module.sg_openvpn_private.security_group_id
  ingress_with_cidr_blocks = [
    {
      rule        = "all-icmp"
      cidr_blocks = join(",", var.private_subnets_cidrs)
    },
  ]
}

data "aws_ami" "openvpn" {
  most_recent = true
  owners      = ["aws-marketplace"]

  filter {
    name   = "description"
    values = ["OpenVPN Access Server 2.8.3 publisher image from https://www.openvpn.net/."]
  }

  filter {
    name   = "product-code"
    values = ["f2ew2wrz425a1jagnifd02u5t"]
  }
}

// Create EC2 instance
module "openvpn" {
  source = "terraform-aws-modules/ec2-instance/aws"
  name   = "openvpn"
  ami    = data.aws_ami.openvpn.id

  # iam_instance_profile = "" todo
  source_dest_check           = false
  instance_type               = "t2.small"
  vpc_security_group_ids      = [module.sg_openvpn_public.security_group_id, module.sg_openvpn_private.security_group_id]
  associate_public_ip_address = true
  availability_zone           = element(module.vpc_dev.azs, 0)
  subnet_id                   = element(module.vpc_dev.public_subnets, 0)

  key_name = var.ami_key_pair_name

}