#variable "AWS_ACCESS_KEY" {}
#variable "AWS_SECRET_KEY" {}

variable "environment_name" {
  description = "The name of environment Infrastructure, this name is used for vpc and eks cluster."
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}


variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "vpc_id" {
  description = "The Version of Kubernetes to deploy"
  type        = string

}

variable "vpc_private_subnets" {
  description = "The Version of Kubernetes to deploy"
  type        = list(string)
  
}




variable "cluster_version" {
  description = "The Version of Kubernetes to deploy"
  type        = string
}


variable "node_group_name" {
  type        = string
  description = "node groups name"
}

variable "karpenter_name" {
  type        = string
  description = "node groups name"
}


variable "karpenter_chart" {
    type = string
    default = "karpenter" # Replace with your name of Karpenter chart
    
}

variable "karpenter_namespace" {
    type = string
    default = "karpenter" # Replace with your name of Karpenter namespace
    
}

variable "karpenter_controller_role" {
    type = string
    default = "karpenter_controller_role" # Replace with your name of karpenter controller role
    
}

variable "karpenter_controller_policy" {
    type = string
    default = "karpenter_controller_policy" # Replace with your name of karpenter controller policy
    
}

