terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.64.0"
    }
  }
}

provider "aws" {
    region = "us-east-1"
}


resource "aws_vpc" "onprem_vpc" {
    cidr_block = var.onprem_vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true


    tags = {
        Name = "${var.onprem}-vpc"
    }
}

resource "aws_vpc_dhcp_options" "onprem_dhcp_options" {
    domain_name = "tunlyinaung.onprem"
    domain_name_servers = [module.ec2.dns_server_private_ip]

    tags = {
        Name = "${var.onprem}-dhcp-options-set"
    }
}

resource "aws_vpc_dhcp_options_association" "onprem_dns_resolver" {
    vpc_id = aws_vpc.onprem_vpc.id
    dhcp_options_id = aws_vpc_dhcp_options.onprem_dhcp_options.id
}

resource "aws_vpc" "cloud_vpc" {
    cidr_block = var.cloud_vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "${var.cloud}-vpc"
    }
}

resource "aws_vpc_peering_connection" "peering" {
    peer_vpc_id = aws_vpc.cloud_vpc.id
    vpc_id = aws_vpc.onprem_vpc.id
    auto_accept = true

    tags = {
        Name = "VPC Peering"
    }

}

module "subnets"{
    source = "./modules/subnets"
    onprem = var.onprem
    onprem_vpc = aws_vpc.onprem_vpc
    cloud = var.cloud
    cloud_vpc = aws_vpc.cloud_vpc
}

module "route_tables"{
    source = "./modules/route_tables"
    onprem = var.onprem
    onprem_vpc = aws_vpc.onprem_vpc
    onprem_public_subnet_1 = module.subnets.onprem_public_subnet_1
    onprem_public_subnet_2 = module.subnets.onprem_public_subnet_2

    cloud = var.cloud
    cloud_vpc = aws_vpc.cloud_vpc
    cloud_public_subnet_1 = module.subnets.cloud_public_subnet_1
    cloud_public_subnet_2 = module.subnets.cloud_public_subnet_2

    onprem_vpc_cidr = var.onprem_vpc_cidr
    cloud_vpc_cidr = var.cloud_vpc_cidr
    peering_id = aws_vpc_peering_connection.peering.id
}

module "security_groups" {
    source = "./modules/security_groups"
    onprem = var.onprem
    onprem_vpc = aws_vpc.onprem_vpc

    cloud = var.cloud
    cloud_vpc = aws_vpc.cloud_vpc
}

module "ec2" {
    source = "./modules/ec2"
    onprem = var.onprem
    onprem_vpc = aws_vpc.onprem_vpc
    onprem_default_sg = module.security_groups.onprem_default_sg
    onprem_public_subnet_1 = module.subnets.onprem_public_subnet_1
    onprem_public_subnet_2 = module.subnets.onprem_public_subnet_2

    cloud = var.cloud
    cloud_default_sg = module.security_groups.cloud_default_sg
    cloud_public_subnet_1 = module.subnets.cloud_public_subnet_1

    ami_id = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name
    private_key_path = var.private_key_path

    onprem_dhcp_options = aws_vpc_dhcp_options.onprem_dhcp_options
}

module "hosted_zone" {
    source = "./modules/hosted_zone"
    cloud = var.cloud
    cloud_vpc = aws_vpc.cloud_vpc
    cloud_app_server_private_ip = module.ec2.cloud_app_server_private_ip
    domain_name = var.domain_name
    cloud_default_sg = module.security_groups.cloud_default_sg
    cloud_public_subnet_1 = module.subnets.cloud_public_subnet_1
    cloud_public_subnet_2 = module.subnets.cloud_public_subnet_2
    onprem_domain_name = var.onprem_domain_name
    onprem_app_server_private_ip = module.ec2.onprem_app_server_private_ip
    onprem_dns_server_private_ip = module.ec2.dns_server_private_ip

}

