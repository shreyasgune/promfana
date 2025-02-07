variable "project_id" {
  type        = string
  description = "Google Cloud project ID"
  default     = "my-project"
}

variable "region" {
  type        = string
  description = "GKE cluster region"
  default     = "value"
}

variable "cluster_name" {
  type        = string
  description = "GKE cluster name"
  default     = "value"
}

variable "node_pool_name" {
  type        = string
  description = "GKE node pool name"
  default     = "value"
}

variable "google_service_account" {
  type        = string
  description = "Google service account"
  default     = "value"
}

# variable "bucket" {
#   type        = string
#   description = "GCS bucket name"
#   default     = "value"
# }

# variable "prefix" {
#   type        = string
#   description = "GCS bucket prefix"
#   default     = "value"
# }

# variable "google_version" {
#   type        = string
#   description = "Google provider version"
#   default     = "value"
# }

variable "ip_cidr_range" {
  type        = string
  description = "IP CIDR range"
  default     = "value"
}

variable "pod_ip_cidr_range" {
  type        = string
  description = "Pod IP CIDR range"
  default     = "value"
}

variable "service_ip_cidr_range" {
  type        = string
  description = "Service IP CIDR range"
  default     = "value"
}

variable "initial_node_count" {
  type        = number
  description = "Initial node count"
  default     = 0
}

variable "logging_service" {
  type        = string
  description = "Logging service"
  default     = "value"
}

variable "monitoring_service" {
  type        = string
  description = "Monitoring service"
  default     = "value"
}

variable "node_locations" {
  type        = list(string)
  description = "Node locations"
  default     = ["value"]
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "Master IPv4 CIDR block"
  default     = "value"
}

variable "node_machine_type" {
  type        = string
  description = "Node machine type"
  default     = "value"
}

variable "autoscaling_min_node_count" {
  type        = number
  description = "Autoscaling min node count"
  default     = 0
}

variable "autoscaling_max_node_count" {
  type        = number
  description = "Autoscaling max node count"
  default     = 0
}




# Define other required variables
