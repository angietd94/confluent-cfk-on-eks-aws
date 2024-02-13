# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "name" {
  description = "Prefix for VPC & EKS Cluster"
  type        = string
  default     = "STS"
}

variable "instance_type" {
  description = "Instance Type For Your EKS Deployment "
  type        = string
  default     = "t3.small"
}