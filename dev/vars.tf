# Tag variables
variable "env" {
  type        = string
  description = "The environment, dev, tst or prd"
  default     = "dev"
}

variable "owner" {
  type        = string
  description = "The owner"
  default     = "tturpin"
}

variable "ami_key_pair_name" {
  type        = string
  description = "The key pair to use for the EC2 instances"
  default     = "turpin.be"
}

variable "my_public_ip" {
  type        = string
  description = "My public ip in the format x.x.x.x/32"
  default     = "178.118.246.6/32"
}

variable "vpc_cidr" {
  type        = string
  description = "The environment vpc cidr x.x.x.x/y"
  default     = "172.31.0.0/16"
}

variable "vpc_azs" {
  type        = list(string)
  description = "The different azs to use, region is set in main.tf"
  default     = ["eu-central-1a", "eu-central-1b"]
}

variable "private_subnets_cidrs" {
  type        = list(string)
  description = "Private subnets x.x.x.x/y"
  default     = ["172.31.48.0/20", "172.31.64.0/20"]
}

variable "public_subnets_cidrs" {
  type        = list(string)
  description = "Public subnets x.x.x.x/y"
  default     = ["172.31.32.0/20", "172.31.0.0/20"]
}

variable "connect_key" {
  type        = string
  description = "In order to generate a unique connect & secret key, e.g. a date YYYYMMDD"
}
