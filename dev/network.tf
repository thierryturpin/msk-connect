##========================================================================================
##                                                                                      ##
##                                          VPC                                         ##
##                                                                                      ##
##========================================================================================

module "vpc_dev" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.env
  cidr = var.vpc_cidr

  azs = var.vpc_azs

  private_subnets     = var.private_subnets_cidrs
  private_subnet_tags = { "Type" = "private" }

  public_subnets     = var.public_subnets_cidrs
  public_subnet_tags = { "Type" = "public" }

  # Do not manage default vpc and route table
  manage_default_vpc         = false
  manage_default_route_table = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  # Default security group - ingress/egress rules cleared to deny all
  manage_default_security_group  = true
  default_security_group_ingress = []
  default_security_group_egress  = []
  default_security_group_name    = "DO_NOT_USE"

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_vpn_gateway = false

}


