
// Create EC2 instance
// cloud init for docker, docker-compose

locals {

  user_data = <<-EOT
  #!/bin/bash
  yum update -y
  amazon-linux-extras install -y docker
  yum install -y git
  systemctl start docker
  systemctl enable docker
  usermod -a -G docker ec2-user
  curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
  curl -L "https://vault.bitwarden.com/download/?app=cli&platform=linux" -o /tmp/bw.zip
  unzip /tmp/bw.zip -d /usr/local/bin/
  chmod +x /usr/local/bin/bw
  EOT

}

module "sg_mssql_private" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = "sg_mssql_private"
  description = "mssql-private"
  vpc_id      = module.vpc_dev.vpc_id

}

module "sg_mssql_private_rule_openvpn" {
  source            = "terraform-aws-modules/security-group/aws"
  create_sg         = false
  security_group_id = module.sg_mssql_private.security_group_id
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
  ]

  number_of_computed_ingress_with_source_security_group_id = 1
}

data "aws_ami" "amazon_linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}



module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"
  name   = "${var.env}-docker-mssql"

  ami = data.aws_ami.amazon_linux-2.id

  # iam_instance_profile = "" todo
  source_dest_check           = true
  instance_type               = "t2.small"
  vpc_security_group_ids      = [module.sg_mssql_private.security_group_id]
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

output "mssql-ec2_instance_dns" {
  value = module.ec2_instance.private_dns
}