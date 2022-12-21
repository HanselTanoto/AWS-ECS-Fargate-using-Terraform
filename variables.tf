# Description: This file is used to specify the variables that will be used in the Terraform configuration.


# Create varible for the AWS Region where the data will be clustered
variable "region" {
    description = "AWS Region"
    default     = "us-east-1"
}

# Create variable for the AWS Availability Zones in the region being used
variable "availability_zones" {
    description = "AWS Availability Zones"
    default     = ["us-east-1a", "us-east-1b"]
}

# Create variable for the AWS Access Key and Secret Key
variable "access_key" {
    description = "AWS Access Key"
    type        = string
}
variable "secret_key" {
    description = "AWS Secret Key"
    type        = string
}

# Create variable for the Virtual Private Cloud (VPC) Classless Inter-Domain Routing (CIDR) block
variable "vpc_cidr" {
    description = "VPC CIDR"
    default     = "10.0.0.0/16"
}

# Create variable for the Public and Private Subnet Classless Inter-Domain Routing (CIDR) blocks
variable "public_subnet_cidrs" {
    description = "Public Subnet CIDRs"
    default     = ["10.0.0.0/24", "10.0.1.0/24"]
}
variable "private_subnet_cidrs" {
    description = "Private Subnet CIDRs"
    default     = ["10.0.2.0/24", "10.0.3.0/24"]
}

