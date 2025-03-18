aws_region       = "us-east-1"
environment_name = "growing_startup"
vpc_cidr         = "172.16.0.0/16"
cluster_version  = "1.31"
node_group_name  = "managed-node"
vpc_id = "vpc-0d5a3c50a2ee31f54"
vpc_private_subnets = ["subnet-00a4cd054d4ec5654", "subnet-06a80a79f2108ab55"]
karpenter_name = "karpenter"