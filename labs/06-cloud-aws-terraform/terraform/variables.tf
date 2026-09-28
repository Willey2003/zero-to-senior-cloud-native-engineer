variable "region" {
  type    = string
  default = "ap-south-1" # Mumbai
}

variable "my_ip_cidr" {
  type        = string
  description = "Your public IP in CIDR form, e.g. 203.0.113.10/32 (find it with: curl ifconfig.me)"
}
