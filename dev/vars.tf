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
  description = "The ssh key name"
  default     = "TT"
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
  description = "The different azs to use"
  default     = ["eu-west-1a", "eu-west-1b"]
}

variable "private_subnets_cidrs" {
  type        = list(string)
  description = "The subnets x.x.x.x/y"
  default     = ["172.31.48.0/20", "172.31.64.0/20"]
}

variable "public_subnets_cidrs" {
  type        = list(string)
  description = "The subnets x.x.x.x/y"
  default     = ["172.31.32.0/20", "172.31.0.0/20"]
}
