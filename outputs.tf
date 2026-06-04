output "target_server_public_ip" {
  value       = aws_instance.target_web_server.public_ip
  description = "The public IP of our newly created server"
}
