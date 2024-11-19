# Provider Configuration
provider "aws" {
  region = "us-east-1" # Replace with your AWS region
}

# Clone the Easy-RSA Repo and Generate Certificates
resource "null_resource" "generate_certificates" {
  provisioner "local-exec" {
    command = <<EOT
      # Ensure the Easy-RSA repo is cloned
      if (!(Test-Path -Path "$HOME\\easy-rsa")) {
        git clone https://github.com/OpenVPN/easy-rsa.git "$HOME\\easy-rsa"
      }
      
      # Navigate to Easy-RSA folder
      Set-Location -Path "$HOME\\easy-rsa\\easyrsa3"
      
      # Initialize PKI
      .\\easyrsa init-pki
      
      # Build CA
      .\\easyrsa build-ca nopass
      
      # Generate server certificate and key
      .\\easyrsa --san=DNS:server build-server-full server nopass
      
      # Generate client certificate and key
      .\\easyrsa build-client-full client1.domain.tld nopass
      
      # Create certificates folder
      $certificatesPath = "$HOME\\certificates"
      if (!(Test-Path -Path $certificatesPath)) {
        New-Item -ItemType Directory -Path $certificatesPath
      }
      
      # Copy certificates and keys
      Copy-Item -Path ".\\pki\\ca.crt" -Destination "$certificatesPath\\ca.crt"
      Copy-Item -Path ".\\pki\\issued\\server.crt" -Destination "$certificatesPath\\server.crt"
      Copy-Item -Path ".\\pki\\private\\server.key" -Destination "$certificatesPath\\server.key"
      Copy-Item -Path ".\\pki\\issued\\client1.domain.tld.crt" -Destination "$certificatesPath\\client1.domain.tld.crt"
      Copy-Item -Path ".\\pki\\private\\client1.domain.tld.key" -Destination "$certificatesPath\\client1.domain.tld.key"
    EOT
    interpreter = ["PowerShell", "-Command"]
  }

  triggers = {
    always_run = timestamp()
  }
}




# # Read Generated Certificates
# data "local_file" "ca_cert" {
#   filename = "${pathexpand("~/certificates/ca.crt")}"
# }

# data "local_file" "server_cert" {
#   filename = "${pathexpand("~/certificates/server.crt")}"
# }

# data "local_file" "server_key" {
#   filename = "${pathexpand("~/certificates/server.key")}"
# }

# data "local_file" "client_cert" {
#   filename = "${pathexpand("~/certificates/client1.domain.tld.crt")}"
# }

# data "local_file" "client_key" {
#   filename = "${pathexpand("~/certificates/client1.domain.tld.key")}"
# }


# # Upload Server Certificate to ACM
# resource "aws_acm_certificate" "server_certificate" {
#   private_key       = data.local_file.server_key.content
#   certificate_body  = data.local_file.server_cert.content
#   certificate_chain = data.local_file.ca_cert.content
# }

# # Optionally Upload Client Certificate to ACM
# resource "aws_acm_certificate" "client_certificate" {
#   private_key       = data.local_file.client_key.content
#   certificate_body  = data.local_file.client_cert.content
#   certificate_chain = data.local_file.ca_cert.content
# }

# # # Create a Client VPN Endpoint
# # resource "aws_ec2_client_vpn_endpoint" "vpn_endpoint" {
# #   client_cidr_block          = "10.0.0.0/16" # Replace with your CIDR block
# #   server_certificate_arn     = aws_acm_certificate.server_certificate.arn
# #   authentication_options {
# #     type                   = "certificate-authentication"
# #     root_certificate_chain = data.local_file.ca_cert.content
# #   }
# #   connection_log_options {
# #     enabled               = true
# #     cloudwatch_log_group  = "client-vpn-log-group"
# #     cloudwatch_log_stream = "client-vpn-log-stream"
# #   }
# #   description                = "Client VPN endpoint with mutual authentication"
# #   split_tunnel               = true
# # }

# # # Create VPN Authorization Rule
# # resource "aws_ec2_client_vpn_authorization_rule" "auth_rule" {
# #   client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn_endpoint.id
# #   target_network_cidr    = "192.168.0.0/16" # Replace with your target network CIDR
# #   authorize_all_groups   = true
# # }

# # # Attach Subnets to the VPN Endpoint
# # resource "aws_ec2_client_vpn_network_association" "vpn_association" {
# #   client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn_endpoint.id
# #   subnet_id              = "subnet-0123456789abcdef0" # Replace with your Subnet ID
# # }
