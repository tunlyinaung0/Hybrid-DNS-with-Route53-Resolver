resource "aws_instance" "onprem_dns" {
    ami = var.ami_id
    instance_type = var.instance_type

    subnet_id = var.onprem_public_subnet_1
    vpc_security_group_ids = [var.onprem_default_sg]
    associate_public_ip_address = true
    private_ip = "10.0.1.100"
    key_name = var.key_name

    connection {
        type = "ssh"
        user = "ubuntu"
        private_key = file(var.private_key_path)
        host = self.public_ip
    }

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get update",
            "sudo apt-get install -y bind9 bind9utils",
        ]
    }

    provisioner "file" {
        source = "named.conf"
        destination = "/tmp/named.conf"
    }

    provisioner "file" {
        source = "named.conf.internal-zones"
        destination = "/tmp/named.conf.internal-zones"
    }

    provisioner "file" {
        source = "tunlyinaung.onprem.lan"
        destination = "/tmp/tunlyinaung.onprem.lan"
    }

    provisioner "file" {
        source = "named.conf.local"
        destination = "/tmp/named.conf.local"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo mv /tmp/named.conf /etc/bind/named.conf",
            "sudo mv /tmp/named.conf.internal-zones /etc/bind/named.conf.internal-zones",
            "sudo mv /tmp/tunlyinaung.onprem.lan /etc/bind/tunlyinaung.onprem.lan",
            "sudo mv /tmp/named.conf.local /etc/bind/named.conf.local",
            "sudo sed -i 's/dnssec-validation auto;/dnssec-validation no;/g' /etc/bind/named.conf.options",
            "sudo sed -i \"/^options {/a\\    allow-query { ${var.onprem_vpc_cidr}; ${var.cloud_vpc_cidr}; };\" /etc/bind/named.conf.options",
            "sudo systemctl restart named",
            "sudo systemctl reboot"
        ]
    }

    tags = {
        Name = "${var.onprem}-dns-server"
    }
}

resource "aws_instance" "onprem_app" {
    ami = var.ami_id
    instance_type = var.instance_type

    subnet_id = var.onprem_public_subnet_2
    vpc_security_group_ids = [var.onprem_default_sg]
    associate_public_ip_address = true
    private_ip = "10.0.2.130"
    key_name = var.key_name

    depends_on = [ 
        aws_instance.onprem_dns,
        var.onprem_dhcp_options
    ]


    tags = {
        Name = "${var.onprem}-app-server"
    }
}

resource "aws_instance" "cloud_app" {
    ami = var.ami_id
    instance_type = var.instance_type

    subnet_id = var.cloud_public_subnet_1
    vpc_security_group_ids = [var.cloud_default_sg]
    associate_public_ip_address = true
    private_ip = "172.31.1.100"
    key_name = var.key_name


    tags = {
        Name = "${var.cloud}-app-server"
    }
  
}
