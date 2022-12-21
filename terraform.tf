# Description: This file is used to configure the Terraform version and the AWS Provider version.


# Specify the required Terraform version and the AWS Provider version.
# The "required_version" argument is used to configure the required Terraform version.
# The "required_providers" block is used to configure the required AWS Provider version.
# The "source" argument is used to configure the AWS Provider source.
terraform {
    required_version = ">= 0.12.0"
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = ">= 2.0.0"
        }
    }
}

# Specify the AWS Provider configuration.
# The AWS Provider is used to interact with the many resources supported by AWS.
# The "region" argument is used to configure the AWS Region.
# The "access key" and "secret key" arguments are used to configure the AWS credentials.
provider "aws" {
    region = var.region
    access_key = var.access_key
    secret_key = var.secret_key
}

