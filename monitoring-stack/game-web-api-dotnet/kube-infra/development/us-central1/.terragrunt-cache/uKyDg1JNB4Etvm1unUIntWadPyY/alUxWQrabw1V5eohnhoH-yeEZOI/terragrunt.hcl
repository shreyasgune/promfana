include "root" {
    path = find_in_parent_folders()
}

terraform {
    source = "../../modules"
}

inputs = {
  environment = "development"
  region      = "us-central1"
  version     = "~> 4.0"
  project_id  = "angelic-digit-297517"
  cluster_name = "us-central1-dev-cluster"
  node_pool_name = "us-central1-dev-node-pool"
  ip_cidr_range = "10.0.0.0/18"
  pod_ip_cidr_range = "10.48.0.0/14"
  service_ip_cidr_range = "10.52.0.0/20"
  
  # Set to 1 for a single-node cluster
  initial_node_count = 1

  # Optional: You can remove autoscaling or keep the minimum/maximum as 1
  autoscaling_min_node_count = 1
  autoscaling_max_node_count = 1

  logging_service = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  node_locations = ["us-central1-b"]

  # Updated node machine type for better performance (adjust as necessary)
  node_machine_type = "e2-medium"  # Ensure it's a standard, non-preemptible type

  # Specify disk size to stay under 250GB
  node_disk_size_gb = 240

  # Ensure no spot instances (do not set `preemptible = true`)
  preemptible = false  # Ensure preemptible is not set to true

  master_ipv4_cidr_block = "172.16.0.0/28"
  google_service_account = "sgune-sa-gke@angelic-digit-297517.iam.gserviceaccount.com"
}

#CHEAPER SOLUTION
# include "root" {
#     path = find_in_parent_folders()
# }
# 
# terraform {
#     source = "../../modules"
# }
# 
# inputs = {
#   environment = "development"
#   region      = "us-central1"
#   version     = "~> 4.0"
#   project_id  = "angelic-digit-297517"
#   cluster_name = "us-central1-dev-cluster"
#   node_pool_name = "us-central1-dev-node-pool"
#   ip_cidr_range = "10.0.0.0/18"
#   pod_ip_cidr_range = "10.48.0.0/14"
#   service_ip_cidr_range = "10.52.0.0/20"
#   initial_node_count = 2
#   logging_service = "logging.googleapis.com/kubernetes"
#   monitoring_service = "monitoring.googleapis.com/kubernetes"
#   node_locations = ["us-central1-b"]
#   node_machine_type = "e2-small"
#   autoscaling_min_node_count = 1
#   autoscaling_max_node_count = 2
#   master_ipv4_cidr_block = "172.16.0.0/28"
#   google_service_account = "sgune-sa-gke@angelic-digit-297517.iam.gserviceaccount.com"
# }
