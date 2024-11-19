variable "generate_private_key" {
  description = "Whether to generate a new private key"
  type        = bool
  default     = true
}

variable "private_key" {
  description = "PEM-encoded private key (used if `generate_private_key` is false)"
  type        = string
  default     = ""
}

variable "private_key_algorithm" {
  description = "Algorithm to use for the private key (e.g., RSA, ECDSA)"
  type        = string
  default     = "RSA"
}

variable "rsa_bits" {
  description = "The size of the RSA key to generate (if RSA is selected)"
  type        = number
  default     = 2048
}

variable "ecdsa_curve" {
  description = "The ECDSA curve to use (if ECDSA is selected)"
  type        = string
  default     = "P256"
}

variable "create_certificate_request" {
  description = "Whether to create a certificate signing request (CSR)"
  type        = bool
  default     = false
}

variable "use_locally_signed_cert" {
  description = "Whether to use a locally signed certificate"
  type        = bool
  default     = false
}

variable "use_self_signed_cert" {
  description = "Whether to use a self-signed certificate"
  type        = bool
  default     = true
}

variable "ca_private_key" {
  description = "CA private key PEM for signing locally signed certificates"
  type        = string
  default     = ""
}

variable "ca_certificate" {
  description = "CA certificate PEM for signing locally signed certificates"
  type        = string
  default     = ""
}

variable "certificate_validity_hours" {
  description = "Validity period of the certificate in hours"
  type        = number
  default     = 8760  # 1 year
}

variable "is_ca" {
  description = "Whether the certificate is a CA certificate"
  type        = bool
  default     = false
}

variable "allowed_uses" {
  description = "List of allowed uses for the certificate"
  type        = list(string)
  default     = ["digital_signature", "key_encipherment"]
}

variable "subject_common_name" {
  description = "Common name (CN) for the certificate subject"
  type        = string
  default     = "example.com"
}

variable "subject_organization" {
  description = "Organization (O) for the certificate subject"
  type        = string
  default     = "Example Org"
}

variable "subject_country" {
  description = "Country (C) for the certificate subject"
  type        = string
  default     = "US"
}

variable "additional_dns_names" {
  description = "List of additional DNS names for the certificate"
  type        = list(string)
  default     = []
}

variable "additional_ip_addresses" {
  description = "List of additional IP addresses for the certificate"
  type        = list(string)
  default     = []
}
