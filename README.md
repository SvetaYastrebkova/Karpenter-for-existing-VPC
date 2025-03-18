# Karpenter-for-existing-VPC


Configuration in this directory creates an AWS EKS cluster with Karpenter provisioned for managing compute resource scaling.
Karpenter is provisioned on top of an EKS Managed Node Group.

#### Prerequisites:

Terraform is installed
AWS CLI is installed and configured
Existing VPC

#### Usage Instructions:

1. Clone the repository

2. Replace the information in terraform.tfvars:

us-east-1 with your AWS region
vpc-xxxxxxxxxxxxxxxxx with your VPC ID
vpc_private_subnets with the IDs of your subnets, etc.

3. To provision the provided configurations you need to execute:

terraform init
terraform plan
terraform apply 

4. Once the cluster is up and running, you can check that Karpenter is functioning as intended with the following command:

# First, make sure you have updated your local kubeconfig

aws eks --region <your_region> update-kubeconfig --name <name>

# Second, deploy the Karpenter NodeClass/NodePool
kubectl apply -f karpenter.yaml

answer:
ec2nodeclass.karpenter.k8s.aws/default created
nodepool.karpenter.sh/default created

# Before: Open the karpenter.yaml file (a manifest for configuring Karpenter, which is used for automatic node management in Kubernetes).

Modify the configuration to specify the requirements for the nodes that Karpenter will create.

# Third, deploy the example deployment

kubectl apply -f inflate.yaml


Node selectors are the way to direct pods/deployment to specific nodes based on labels. 
example:

spec:
      nodeSelector:
        kubernetes.io/arch: amd64 # use For x86, arm64 - use for Graviton

Below you can see example.yaml: 
For Graviton: 

apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-graviton-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: my-graviton-app
  template:
    metadata:
      labels:
        app: my-graviton-app
    spec:
      nodeSelector:
        kubernetes.io/arch: arm64
      containers:
      - name: my-container
        image: your-graviton-compatible-image:latest

# You can watch Karpenter's controller logs with

kubectl logs -f -n kube-system -l app.kubernetes.io/name=karpenter -c controller

Validate if the Amazon EKS Addons Pods are running in the Managed Node Group and the inflate application Pods are running on Karpenter provisioned Nodes.

kubectl get nodes -L karpenter.sh/registered

NAME                            STATUS   ROLES    AGE     VERSION               REGISTERED
ip-172-16-42-187.ec2.internal   Ready    <none>   4m22s   v1.32.0-eks-2e66e76
ip-172-16-46-82.ec2.internal    Ready    <none>   4m22s   v1.32.0-eks-2e66e76


kubectl get pods -A -o custom-columns=NAME:.metadata.name,NODE:.spec.nodeName

NAME                           NODE
inflate-7b4df768d6-5dwkx       <none>
inflate-7b4df768d6-7wjxs       ip-172-16-46-82.ec2.internal
inflate-7b4df768d6-9xrq7       <none>
inflate-7b4df768d6-hk5tr       <none>
inflate-7b4df768d6-zp9cn       ip-172-16-42-187.ec2.internal
aws-node-n6pxp                 ip-172-16-46-82.ec2.internal
aws-node-z6nlb                 ip-172-16-42-187.ec2.internal
coredns-6b9575c64c-gm9hb       ip-172-16-46-82.ec2.internal
coredns-6b9575c64c-smb4r       ip-172-16-46-82.ec2.internal
eks-pod-identity-agent-vmwpj   ip-172-16-46-82.ec2.internal
eks-pod-identity-agent-zz6wd   ip-172-16-42-187.ec2.internal
karpenter-7ccd747c68-7wr6p     ip-172-16-46-82.ec2.internal
karpenter-7ccd747c68-dxn6f     ip-172-16-42-187.ec2.internal
kube-proxy-5hgf5               ip-172-16-46-82.ec2.internal
kube-proxy-rjvjg               ip-172-16-42-187.ec2.internal


#### Tear Down & Clean-Up

Because Karpenter manages the state of node resources outside of Terraform, Karpenter created resources will need to be de-provisioned first before removing the remaining resources with Terraform.

Remove the example deployment created above and any nodes created by Karpenter

kubectl delete deployment inflate

Remove the resources created by Terraform

terraform destroy --auto-approve

