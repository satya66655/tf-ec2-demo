output "instance_id" { value = aws_instance.this.id }
output "public_ip"   { value = aws_instance.this.public_ip }
output "public_dns"  { value = aws_instance.this.public_dns }
output "http_url"    { value = "http://${aws_instance.this.public_ip}" }
output "ssh_example" {
  value = "ssh -i ~/PATH/TO/886436941748_NV-Mar-25.pem ec2-user@${aws_instance.this.public_ip}"
}

