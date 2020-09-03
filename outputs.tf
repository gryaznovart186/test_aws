output "public_ip" {
  value = aws_instance.centos_wm.public_ip
}

output "public_dns" {
  value = aws_instance.centos_wm.public_dns
}