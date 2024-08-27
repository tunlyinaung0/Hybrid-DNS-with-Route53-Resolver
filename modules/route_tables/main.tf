resource "aws_internet_gateway" "onprem_igw" {
    vpc_id = var.onprem_vpc.id

    tags = {
        Name = "${var.onprem}-igw"
    }
}

resource "aws_route_table" "onprem_public_rtb" {
    vpc_id = var.onprem_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.onprem_igw.id
    }

    route {
        cidr_block = var.cloud_vpc_cidr
        vpc_peering_connection_id = var.peering_id
        
    }

    tags = {
        Name = "${var.onprem}-public-rtb"
    }
}


resource "aws_route_table_association" "onprem_public_rtb_association_1" {
    subnet_id = var.onprem_public_subnet_1
    route_table_id = aws_route_table.onprem_public_rtb.id

}

resource "aws_route_table_association" "onprem_public_rtb_association_2" {
    subnet_id = var.onprem_public_subnet_2
    route_table_id = aws_route_table.onprem_public_rtb.id
}


resource "aws_internet_gateway" "cloud_igw" {
    vpc_id = var.cloud_vpc.id

    tags = {
        Name = "${var.cloud}-igw"
    }
}

resource "aws_route_table" "cloud_public_rtb" {
    vpc_id = var.cloud_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.cloud_igw.id
    }

    route {
        cidr_block = var.onprem_vpc_cidr
        vpc_peering_connection_id = var.peering_id
    }

    tags = {
        Name = "${var.cloud}-public-rtb"
    }
}


resource "aws_route_table_association" "cloud_public_rtb_association_1" {
    subnet_id = var.cloud_public_subnet_1
    route_table_id = aws_route_table.cloud_public_rtb.id

}

resource "aws_route_table_association" "cloud_public_rtb_association_2" {
    subnet_id = var.cloud_public_subnet_2
    route_table_id = aws_route_table.cloud_public_rtb.id
}