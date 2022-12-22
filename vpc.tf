# Description: This file is used to configure the Virtual Private Cloud (VPC), Internet Gateway, Public Subnet, Private Subnet, Route Table, and Route Table Association.


# Create Virtual Private Cloud (VPC).
# VPC is a virtual network that is logically isolated from other virtual networks in the AWS Cloud.
# It is a virtual representation of your network in the AWS Cloud.
resource "aws_vpc" "vpc" {
    cidr_block  = var.vpc_cidr
    instance_tenancy = "default"
    enable_dns_hostnames = true
}

# Create Internet Gateway and attach it to VPC.
# Internet gateway is used to connect the VPC to the internet.
resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.vpc.id
}

# Create Public Subnet.
# Public subnet used to host the Application Load Balancer (ALB) and the ECS Fargate Service.
resource "aws_subnet" "public_subnet" {
    count                   = length(var.public_subnet_cidrs)
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = var.public_subnet_cidrs[count.index]
    availability_zone       = var.availability_zones[count.index]
    map_public_ip_on_launch = true
}

# Create Private Subnet.
# Private subnet used to host the ECS Fargate Service.
resource "aws_subnet" "private_subnet" {
    count                   = length(var.private_subnet_cidrs)
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = var.private_subnet_cidrs[count.index]
    availability_zone       = var.availability_zones[count.index]
    map_public_ip_on_launch = false
}

# Create Route Table and add public route.
# Route table is a set of rules, called routes, that are used to determine 
# where network traffic from the subnet or gateway is directed.
resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }
}

# Associate Public Subnet with Public Route Table.
resource "aws_route_table_association" "public_subnet_route_table_association" {
    count           = length(var.public_subnet_cidrs)
    subnet_id       = aws_subnet.public_subnet[count.index].id
    route_table_id  = aws_route_table.public_route_table.id
}

# Create Elastic IP for NAT Gateway.
# Elastic IP is a static IPv4 address designed for dynamic cloud computing.
resource "aws_eip" "nat_eip" {
    count = length(var.private_subnet_cidrs)
    vpc   = true
}

# Create NAT Gateway and attach it to Public Subnet.
# NAT Gateway is a managed service that makes it easy to connect to the 
# internet from instances within a private subnet in an AWS VPC.
resource "aws_nat_gateway" "nat_gateway" {
    count           = length(var.private_subnet_cidrs)
    allocation_id   = aws_eip.nat_eip[count.index].id
    subnet_id       = aws_subnet.public_subnet[count.index].id
    depends_on      = [aws_internet_gateway.internet_gateway]
}

# Create Private Route Table and add private route
resource "aws_route_table" "private_route_table" {
    count           = length(var.private_subnet_cidrs)
    vpc_id          = aws_vpc.vpc.id
    route {
        cidr_block      = "0.0.0.0/0"
        nat_gateway_id  = aws_nat_gateway.nat_gateway[count.index].id
    }
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private_subnet_route_table_association" {
    count           = length(var.private_subnet_cidrs)
    subnet_id       = aws_subnet.private_subnet[count.index].id
    route_table_id  = aws_route_table.private_route_table[count.index].id
}

