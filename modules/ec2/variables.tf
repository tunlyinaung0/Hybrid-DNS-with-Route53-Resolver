variable "ami_id" {}
variable "instance_type" {}

variable "onprem_vpc" {}
variable "onprem" {}   

variable "key_name" {}
variable "private_key_path" {}

variable "onprem_default_sg" {}

variable "onprem_public_subnet_1" {}
variable "onprem_public_subnet_2" {}

variable "cloud" {}
variable "cloud_default_sg"  {}
variable "cloud_public_subnet_1" {}

variable "onprem_dhcp_options" {}