resource "aws_subnet" "onprem_public_subnet_1" {
    vpc_id = var.onprem_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"

    tags = {
        Name = "${var.onprem}-public-subnet-1"
    }
}

resource "aws_subnet" "onprem_public_subnet_2" {
    vpc_id = var.onprem_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"

    tags = {
        Name = "${var.onprem}-public-subnet-2"
    }
}

resource "aws_subnet" "cloud_public_subnet_1" {
    vpc_id = var.cloud_vpc.id
    cidr_block = "172.31.1.0/24"
    availability_zone = "us-east-1a"

    tags = {
        Name = "${var.cloud}-public-subnet-1"
    }
}

resource "aws_subnet" "cloud_public_subnet_2" {
    vpc_id = var.cloud_vpc.id
    cidr_block = "172.31.2.0/24"
    availability_zone = "us-east-1b"

    tags = {
        Name = "${var.cloud}-public-subnet-2"
    }
}