locals {
  private_key_required = var.generate_private_key || var.private_key == ""
}

resource "tls_private_key" "generated_key" {
  count    = local.private_key_required ? 1 : 0
  algorithm = var.private_key_algorithm

  rsa_bits    = var.private_key_algorithm == "RSA" ? var.rsa_bits : null
  ecdsa_curve = var.private_key_algorithm == "ECDSA" ? var.ecdsa_curve : null
}

resource "tls_cert_request" "csr" {
  count = var.create_certificate_request ? 1 : 0

  private_key_pem = local.private_key_required ? tls_private_key.generated_key[0].private_key_pem : var.private_key

  subject {
    common_name  = var.subject_common_name
    organization = var.subject_organization
    country      = var.subject_country
  }

  dns_names    = var.additional_dns_names
  ip_addresses = var.additional_ip_addresses
}

resource "tls_locally_signed_cert" "local_cert" {
  count = var.use_locally_signed_cert ? 1 : 0

  cert_request_pem   = tls_cert_request.csr[0].cert_request_pem
  ca_private_key_pem = var.ca_private_key
  ca_cert_pem        = var.ca_certificate

  validity_period_hours = var.certificate_validity_hours
  is_ca_certificate     = var.is_ca

  allowed_uses = var.allowed_uses
}

resource "tls_self_signed_cert" "self_signed_cert" {
  count = var.use_self_signed_cert ? 1 : 0

  private_key_pem = local.private_key_required ? tls_private_key.generated_key[0].private_key_pem : var.private_key

  validity_period_hours = var.certificate_validity_hours
  is_ca_certificate     = var.is_ca

  allowed_uses = var.allowed_uses

  subject {
    common_name  = var.subject_common_name
    organization = var.subject_organization
    country      = var.subject_country
  }

  dns_names    = var.additional_dns_names
  ip_addresses = var.additional_ip_addresses
}

output "certificate_pem" {
  value = var.use_locally_signed_cert ? tls_locally_signed_cert.local_cert[0].cert_pem : tls_self_signed_cert.self_signed_cert[0].cert_pem
}

output "private_key_pem" {
  value = local.private_key_required ? tls_private_key.generated_key[0].private_key_pem : var.private_key
}
