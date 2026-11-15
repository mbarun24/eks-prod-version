# Pathnex EKS Terraform

Terraform manages the EKS cluster, node group, IAM roles and policies, add-ons,
Helm releases, and gp3 StorageClass. Configure deployment inputs in a tfvars file.
The checked-in terraform.tfvars preserves the existing deployment's names.

## Existing deployment

Run `terraform plan` before applying. Applying against the same state reconciles
the current deployment; it does not create a second cluster.

## Recreate this deployment from scratch

Keep the current terraform.tfvars and state. Destroy through Terraform while
its cluster API is still reachable, then create again:

```sh
terraform plan -destroy -out=destroy.tfplan
terraform apply destroy.tfplan
terraform plan -out=tfplan
terraform apply tfplan
```

This destroys all resources managed by this state, including IAM roles and Helm
releases. Existing VPC networking and SSH keys are external inputs and remain.
Do not delete the cluster manually or remove state before Terraform cleans up
its Kubernetes resources. If a fresh full plan cannot initialize Kubernetes,
use the bootstrap fallback below with the current tfvars (omit `-var-file`).

## New deployment

Copy `fresh.tfvars.example` to a new environment file, replace the subnet and
security group IDs, and select a supported Kubernetes version and instance type.
Subnets, VPC, security groups, and an optional EC2 SSH key must already exist.
This repository does not create those networking resources.

Use separate state for each cluster, for example:

```sh
terraform init
terraform workspace new pathnex-new
terraform plan -var-file=new.tfvars -out=tfplan
terraform apply tfplan
```

Use a unique cluster name. Omit IAM name overrides so roles and policies derive
from that cluster name. Values in new.tfvars override terraform.tfvars, so set
these to null in new.tfvars when using this directory's existing tfvars:

```hcl
cluster_role_name      = null
node_role_name         = null
ebs_csi_role_name      = null
autoscaler_role_name   = null
autoscaler_policy_name = null
ssh_key_name           = null
```

The cluster uses `aws_iam_role.eks_cluster.arn` directly and waits for its policy
attachment. Helm recovery imports are no longer configured.

Helm and Kubernetes providers require a reachable cluster API. If an empty-state
plan cannot initialize those providers before the cluster exists, bootstrap the
AWS infrastructure first, then run the full plan/apply:

```sh
terraform plan -var-file=new.tfvars -target=aws_eks_node_group.pathnex-NG -out=bootstrap.tfplan
terraform apply bootstrap.tfplan
terraform plan -var-file=new.tfvars -out=tfplan
terraform apply tfplan
```

Targeting is only a bootstrap fallback; always finish with the full apply.
The node group's desired size is ignored after creation so autoscalers can own it.

Channel: https://www.youtube.com/@pathnex
