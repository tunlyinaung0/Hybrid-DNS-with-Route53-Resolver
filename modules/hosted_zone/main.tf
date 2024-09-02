resource "aws_route53_zone" "private_hosted_zone" {
    name = var.domain_name
    vpc {
        vpc_id = var.cloud_vpc.id
        vpc_region = "us-east-1"
    }

    tags = {
        Name = "${var.cloud}-Private-Hosted-Zone"
    }
}


resource "aws_route53_record" "app" {
    zone_id = aws_route53_zone.private_hosted_zone.zone_id
    name = "app"
    type = "A"
    ttl = 300
    records = [var.cloud_app_server_private_ip]

}

resource "aws_route53_resolver_endpoint" "outbound_endpoint" {
    name      = "outbound-resolver-endpoint"
    direction = "OUTBOUND"
    security_group_ids = [var.cloud_default_sg]

    ip_address {
        subnet_id = var.cloud_public_subnet_1
    }

    ip_address {
        subnet_id = var.cloud_public_subnet_2
    }

    tags = {
        Name = "${var.cloud}-outbound-resolver-endpoint"
    }
}

resource "aws_route53_resolver_endpoint" "inbound_endpoint" {
    name      = "inbound-resolver-endpoint"
    direction = "INBOUND"
    security_group_ids = [var.cloud_default_sg]

    ip_address {
        subnet_id = var.cloud_public_subnet_1
        ip = "172.31.1.110"
    }

    ip_address {
        subnet_id = var.cloud_public_subnet_2
        ip = "172.31.2.110"
    }

    protocols = ["Do53"]


    tags = {
        Name = "${var.cloud}-inbound-resolver-endpoint"
    }
}

resource "aws_route53_resolver_rule" "forward_rule" {
    name = "forward-resolver-rule"
    domain_name = var.onprem_domain_name
    rule_type = "FORWARD"
    resolver_endpoint_id = aws_route53_resolver_endpoint.outbound_endpoint.id

    target_ip {
        ip = "${var.onprem_dns_server_private_ip}"
    }

    tags = {
        Name = "${var.cloud}-forward-resolver-rule"
    }

}

resource "aws_route53_resolver_rule_association" "forward_rule_associate" {
    resolver_rule_id = aws_route53_resolver_rule.forward_rule.id
    vpc_id = var.cloud_vpc.id
}