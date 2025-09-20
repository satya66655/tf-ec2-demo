variable "key_name" {
  description = "Existing EC2 key pair name (not the .pem path)"
  type        = string
}

variable "instance_name" {
  type    = string
  default = "demo-ec2"
}

