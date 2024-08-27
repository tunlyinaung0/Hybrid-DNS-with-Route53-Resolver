output "dns_server_public_ip" {
    value = aws_instance.onprem_dns.public_ip
}

output "dns_server_private_ip" {
    value = aws_instance.onprem_dns.private_ip
}

output "onprem_app_server_public_ip" {
    value = aws_instance.onprem_app.public_ip
}

output "onprem_app_server_private_ip" {
    value = aws_instance.onprem_app.private_ip
}

output "cloud_app_server_public_ip" {
    value = aws_instance.cloud_app.public_ip
}

output "cloud_app_server_private_ip" {
    value = aws_instance.cloud_app.private_ip
}