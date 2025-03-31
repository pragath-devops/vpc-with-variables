variable "region-name" {
  type        = string
  default     = "ap-south-1"
  description = "This is region details"
}

variable "profile-name" {
  type        = string
  default     = "default"
  description = "Adding AWS CLI profile to access AWS resources"
}

variable "vpccidr" {
  type        = string
  default     = "10.10.0.0/16"
  description = "this is VPC CIDR for provision"
}

variable "vpc-name" {
  type        = string
  default     = "dev-vpc"
  description = "Create VPC name"
}


variable "pub-sub-1a-cidr" {
  type        = string
  default     = "10.10.0.0/22"
  description = "this is pub subnet 1a  CIDR"
}
variable "pub-sub-1b-cidr" {
  type        = string
  default     = "10.10.4.0/22"
  description = "this is pub subnet 1b  CIDR"
}
variable "pub-sub-1c-cidr" {
  type        = string
  default     = "10.10.8.0/22"
  description = "this is pub subnet 1c  CIDR"
}

variable "pri-sub-1a-cidr" {
  type        = string
  default     = "10.10.16.0/20"
  description = "this is pri subnet 1a  CIDR"
}
variable "pri-sub-1b-cidr" {
  type        = string
  default     = "10.10.32.0/20"
  description = "this is pri subnet 1b  CIDR"
}
variable "pri-sub-1c-cidr" {
  type        = string
  default     = "10.10.48.0/20"
  description = "this is pri subnet 1c  CIDR"
}
variable "environment" {
  type        = string
  default     = "dev"
  description = "ENV name"
}


variable "imageid" {
  type        = string
  default     = "ami-00bb6a80f01f03502"
  description = "AMI ID for EC2"
}


variable "ec2-instance-type" {
  type        = string
  default     = "t3a.medium"
  description = "EC2 instance type"
}

variable "ec2-pem-key" {
  type        = string
  default     = "test-delete"
  description = "pem key for connect EC2"
}
