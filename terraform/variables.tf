variable "key_name" {
  description = "Existing EC2 key pair name (not the .pem path)"
  type        = string
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "demo-ec2"
}

variable "subnet_id" {
  description = "Existing subnet ID (e.g., subnet-xxxxxxxx)"
  type        = string
}

variable "security_group_id" {
  description = "Existing security group ID (e.g., sg-xxxxxxxx)"
  type        = string
}

