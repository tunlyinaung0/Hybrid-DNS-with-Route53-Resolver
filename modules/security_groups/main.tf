resource "aws_default_security_group" "onprem_default_sg" {
    vpc_id = var.onprem_vpc.id


    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.onprem}-default-sg"
    }
}



resource "aws_default_security_group" "cloud_default_sg" {
    vpc_id = var.cloud_vpc.id


    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.cloud}-default-sg"
    }
}