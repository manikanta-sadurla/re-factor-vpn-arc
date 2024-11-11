provider "aws" {
  region = "us-east-1"
}

# Security Group for VPN
resource "aws_security_group" "vpn_sg" {
  name   = "vpn_security_group"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpn_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# AWS Client VPN Endpoint with Certificate-Based Authentication
resource "aws_ec2_client_vpn_endpoint" "vpn_endpoint" {
  client_cidr_block    = var.vpn_cidr
  server_certificate_arn = aws_acm_certificate.default[0].arn

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.default[0].arn
  }

  connection_log_options {
    enabled                = true
    cloudwatch_log_group   = aws_cloudwatch_log_group.vpn_log_group.name
    cloudwatch_log_stream  = aws_cloudwatch_log_stream.vpn_log_stream.name
  }

  security_group_ids = [aws_security_group.vpn_sg.id]
  vpc_id             = var.vpc_id
}

resource "aws_cloudwatch_log_group" "vpn_log_group" {
  name              = "/aws/vpn"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_stream" "vpn_log_stream" {
  name           = "vpn_log_stream"
  log_group_name = aws_cloudwatch_log_group.vpn_log_group.name
}


resource "aws_ec2_client_vpn_authorization_rule" "this" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn_endpoint.id
  target_network_cidr    = var.vpn_cidr
  authorize_all_groups   = true
}

resource "aws_ec2_client_vpn_network_association" "this" {
  count                  = length(var.subnet_ids)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn_endpoint.id
  subnet_id              = var.subnet_ids[count.index]
  vpc_id                 = var.vpc_id
}

# resource "aws_ec2_client_vpn_endpoint" "this" {
#   description              = "AWS Client VPN endpoint for secure access"
#   client_cidr_block        = var.vpn_cidr
#   server_certificate_arn   = var.server_certificate_arn
#   authentication_options {
#     type                       = "directory-service-authentication"
#     active_directory_id        = var.authentication_arn
#   }
#   connection_log_options {
#     enabled                   = true
#     cloudwatch_log_group      = "/aws/vpn/logs"
#     cloudwatch_log_stream     = "client-vpn-stream"
#   }
#   dns_servers               = ["8.8.8.8", "8.8.4.4"]
#   split_tunnel              = true
#   transport_protocol        = "udp"
#   security_group_ids        = [var.security_group_id]
#   tags = {
#     Name = var.client_vpn_name
#   }
# }