output "client_vpn_endpoint_id" {
  description = "ID of the Client VPN endpoint."
  value       = aws_ec2_client_vpn_endpoint.this.id
}

output "client_vpn_endpoint_dns" {
  description = "DNS name of the Client VPN endpoint."
  value       = aws_ec2_client_vpn_endpoint.this.dns_name
}
