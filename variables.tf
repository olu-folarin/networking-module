variable "whitelisted_ips" {
  description = "List of IP addresses to whitelist"
  type        = list(string)
  default = [
    "203.0.113.1/32", "203.0.113.2/32", "203.0.113.3/32", "203.0.113.4/32",
    "203.0.113.5/32", "203.0.113.6/32", "203.0.113.7/32", "203.0.113.8/32",
    "203.0.113.9/32", "203.0.113.10/32", "203.0.113.11/32", "203.0.113.12/32",
    "203.0.113.13/32", "203.0.113.14/32", "203.0.113.15/32", "203.0.113.16/32",
    "203.0.113.17/32", "203.0.113.18/32", "203.0.113.19/32", "203.0.113.20/32"
  ]
}

variable "region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "eu-west-2"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_vpn_gateway" {
  description = "value to enable vpn gateway"
  type        = bool
  default     = false
}

variable "public_subnet_count" {
  description = "The number of public subnets to create"
  type        = number
  default     = 2
}

variable "private_subnet_count" {
  description = "The number of private subnets to create"
  type        = number
  default     = 2
}

variable "private_subnet_cidr_blocks" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet_cidr_blocks" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

# variable "tags" {
#   description = "A map of tags to add to all resources"
#   type        = map(string)
#   default     = {
#     owner = "folarin"
#     environment = "Dev"
#     project = "terraform-core"
#   }
# }