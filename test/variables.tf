# variable "domain_name" {
#   description = "The domain name for the certificate"
#   type        = string
#   default     = "example.com"
# }

variable "certificate_chain" {
  description = "Optional chain for the certificate"
  type        = object({
    cert_pem = string
  })
  default = {
    cert_pem = ""
  }
}

variable "private_key_contents" {
  description = "Private key content if provided, otherwise a key will be generated"
  type        = string
  default     = ""
}

########################### VPN ###########################

# # CIDR block for Client VPN
# variable "vpn_cidr" {
#   description = "CIDR block for the Client VPN"
#   type        = string
#   default     = "10.0.0.0/16"
# }

# VPC ID where the Client VPN and Security Group will be created
variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

# List of Subnet IDs for Client VPN association
variable "subnet_ids" {
  description = "List of Subnet IDs for Client VPN network association"
  type        = list(string)
}

# ARN of the server certificate for Client VPN authentication
# variable "server_certificate_arn" {
#   description = "ARN of the ACM certificate for Client VPN server authentication"
#   type        = string
# }

# # ARN of the root certificate chain for client authentication
# variable "root_certificate_chain_arn" {
#   description = "ARN of the root certificate chain for Client VPN client authentication"
#   type        = string
# }

# CloudWatch log group name for VPN logging
variable "log_group_name" {
  description = "Name of the CloudWatch log group for VPN connection logging"
  type        = string
  default     = "/aws/vpn"
}

# CloudWatch log stream name for VPN logging
variable "log_stream_name" {
  description = "Name of the CloudWatch log stream for VPN connection logging"
  type        = string
  default     = "vpn_log_stream"
}

# Retention period for the CloudWatch log group
variable "log_retention_days" {
  description = "Retention period in days for the CloudWatch log group"
  type        = number
  default     = 7
}

# Variables
variable "vpn_cidr" {
  description = "CIDR block for the Client VPN"
  type        = string
  default     = "10.12.0.0/16"
}