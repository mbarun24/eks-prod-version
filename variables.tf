variable "aws_region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "public_access_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "node_group_name" {
  type    = string
  default = "practice-ng"
}

variable "node_ami_type" {
  type    = string
  default = "AL2023_x86_64_STANDARD"
}

variable "node_capacity_type" {
  type    = string
  default = "SPOT"
}

variable "node_instance_types" {
  type    = list(string)
  default = ["c7i-flex.large"]
}

variable "node_disk_size" {
  type    = number
  default = 20
}

variable "ssh_key_name" {
  type    = string
  default = null
}

variable "ssh_security_group_ids" {
  type    = list(string)
  default = []
}

variable "cluster_role_name" {
  type        = string
  default     = null
  description = "Optional override; defaults to a name derived from cluster_name."
}

variable "node_role_name" {
  type        = string
  default     = null
  description = "Optional override; defaults to a name derived from cluster_name."
}

variable "ebs_csi_role_name" {
  type        = string
  default     = null
  description = "Optional override; defaults to a name derived from cluster_name."
}

variable "autoscaler_role_name" {
  type        = string
  default     = null
  description = "Optional override; defaults to a name derived from cluster_name."
}

variable "autoscaler_policy_name" {
  type        = string
  default     = null
  description = "Optional override; defaults to a name derived from cluster_name."
}

variable "node_scaling" {
  type = object({
    desired_size = number
    min_size     = number
    max_size     = number
  })
  default = {
    desired_size = 3
    min_size     = 1
    max_size     = 5
  }
  validation {
    condition = (
      var.node_scaling.min_size >= 0 &&
      var.node_scaling.min_size <= var.node_scaling.desired_size &&
      var.node_scaling.desired_size <= var.node_scaling.max_size
    )
    error_message = "Scaling must satisfy 0 <= min_size <= desired_size <= max_size."
  }
}

