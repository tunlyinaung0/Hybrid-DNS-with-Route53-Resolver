output "onprem_default_sg" {
    value = aws_default_security_group.onprem_default_sg.id
}

output "cloud_default_sg" {
    value = aws_default_security_group.cloud_default_sg.id
}