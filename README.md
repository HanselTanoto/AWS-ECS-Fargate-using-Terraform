# AWS ECS Fargate
Amazon ECS Cluster using Fargate launch type behind an application load balancer implemented in Terraform

## Resources
- VPC (Virtual Private Cloud)
- One public and one private subnet per availability zone
- Routing tables for each subnets
- Internet Gateway for public subnets
- NAT gateways with attached Elastic IPs for the private subnet
- Security groups for Load Balancer and the ECS Cluster
- Aplication Load Balancer with target group and listeners for port 80
- An ECS cluster with a service and task definition

![image](https://user-images.githubusercontent.com/70782721/209073420-eb73b096-bbee-4b27-b31f-66e18b7f6e47.png)

(Source: https://miro.medium.com/max/1049/1*zmk2GDtVpArs3lysisYEZQ.png)

## Requirements
| Name | Version |
|------|---------|
| [Terraform](https://developer.hashicorp.com/terraform/downloads) | >= 0.12.0 |
| [AWS Provider](https://releases.hashicorp.com/terraform-provider-aws/) | >= 2.0.0 |
| AWS Account | - |

## How to build the infrastructure
- Clone this repository or download the source code from this repository.
- Create your own `keys.tfvars` based on `keysexample.tfvars`, insert the values for your AWS access key and secret key.
- Execute `terraform init` in your CLI to initialize your Terraform.
- Execute `terraform apply -var-file="keys.tfvars"` to execute the program.

Then, the infrastructure has been successfully built. To destroy all resources, execute `terraform destroy -var-file="keys.tfvars"`.

## Created by
[Hansel Valentino Tanoto](https://github.com/HanselTanoto) - K02 - 13520046
