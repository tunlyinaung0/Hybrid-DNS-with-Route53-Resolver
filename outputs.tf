output "onprem_dns_server_public_ip" {
    value = module.ec2.dns_server_public_ip
}

output "onprem_app_server_public_ip" {
    value = module.ec2.onprem_app_server_public_ip
}

output "cloud_app_server_public_ip" {
    value = module.ec2.cloud_app_server_public_ip
}

