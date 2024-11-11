# Set up local variables for configuration settings
locals {
  acm_enabled = true
  tls_certificate = try(tls_self_signed_cert.default[0].cert_pem, tls_locally_signed_cert.default[0].cert_pem, null)
  tls_key = try(tls_private_key.default[0].private_key_pem, var.private_key_contents)
}

# Generate a private key (optional)
resource "tls_private_key" "default" {
  count       = local.acm_enabled ? 1 : 0
  algorithm   = "RSA"
  rsa_bits    = 2048
}

# Generate a certificate signing request
resource "tls_cert_request" "default" {
  count            = local.acm_enabled ? 1 : 0
  private_key_pem  = tls_private_key.default[0].private_key_pem

  subject {
    common_name   = "example.com"
    organization  = "ExampleOrg"
    locality      = "City"
    country       = "Country"
  }
}

# Self-signed or locally signed certificate
resource "tls_self_signed_cert" "default" {
  count                = local.acm_enabled ? 1 : 0
  private_key_pem      = tls_private_key.default[0].private_key_pem
  validity_period_hours = 8760  # Valid for 1 year
  allowed_uses         = ["server_auth"]

  subject {
    common_name = "example.com"
  }
}

# ACM Certificate with imported certificate data if needed
resource "aws_acm_certificate" "default" {
  count             = local.acm_enabled ? 1 : 0
  private_key       = local.tls_key
  certificate_body  = local.tls_certificate
  certificate_chain = var.certificate_chain.cert_pem

# #   domain_name       = var.domain_name
#   validation_method = "DNS"
}

# Store certificate ARN for use
output "server_certificate_arn" {
  value = aws_acm_certificate.default[0].arn
}
