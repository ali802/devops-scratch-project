
variable "aws_region" {
  type        = string
  description = "The AWS region to deploy resources into"
}

variable "ssh_key_name" {
  type        = string
  description = "The name of your existing AWS EC2 Key Pair"
}

variable "state_bucket_name" {
  type        = string
  description = "The globally unique name for the S3 bucket"
}
