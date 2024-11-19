vpc_id                   = "vpc-0e6c09980580ecbf6"  # Replace with your actual VPC ID
subnet_ids               = ["subnet-064b80a494fed9835", "subnet-066d0c78479b72e77"]  # Replace with your actual Subnet IDs
# server_certificate_arn   = "arn:aws:acm:region:account-id:certificate/server-certificate-arn"  # Replace with your ACM server certificate ARN
# root_certificate_chain_arn = "arn:aws:acm:region:account-id:certificate/root-certificate-chain-arn"  # Replace with your ACM root certificate ARN
log_group_name           = "/aws/vpn"
log_stream_name          = "vpn_log_stream"
log_retention_days       = 7
