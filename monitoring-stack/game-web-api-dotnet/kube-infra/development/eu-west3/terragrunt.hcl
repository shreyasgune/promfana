

include "root" {
    path = find_in_parent_folders()
}


inputs = {
  environment = "development"
  region      = "europe-west3"
  version     = "~> 4.0"
  project_id  = "angelic-digit-297517"
  cluster_name = "europe-west3-dev-cluster"
  node_pool_name = "europe-west3-dev-node-pool"
  ip_cidr_range = "10.0.0.0/18"
  pod_ip_cidr_range = "10.48.0.0/14"
  service_ip_cidr_range = "10.52.0.0/20"
  initial_node_count = 2
  logging_service = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  node_locations = ["europe-west3-a"]
  node_machine_type = "e2-medium"
  autoscaling_min_node_count = 1
  autoscaling_max_node_count = 2
  master_ipv4_cidr_block = "172.16.0.0/28"
  google_service_account = "sgune-sa-gke@angelic-digit-297517.iam.gserviceaccount.com"
}
