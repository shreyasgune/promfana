resource "google_container_cluster" "primary" {
  name = var.cluster_name
  # if you choose just a region without a zone, GKE will create an HA cluster in different zones, but it will be expense. I'm choosing a zone so that I don't have to pay more
  location                 = var.region
  initial_node_count       = var.initial_node_count
  network                  = google_compute_network.main.self_link
  subnetwork               = google_compute_subnetwork.private.self_link
  remove_default_node_pool = true
  # This will install a fluetd logging agent on each node and do the scraping of logs from the containers but it will cost you more. If your developer enables debug logs, your cost can skyrocket. Same with monitoring. What you want to do is install Prometheus, Grafana, and Loki on your cluster and scrape the logs and metrics from there.
  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service

  networking_mode    = "VPC_NATIVE"

  release_channel {
    channel = "REGULAR"
  }

  node_locations = var.node_locations

  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pods-range"
    services_secondary_range_name = "k8s-services-range"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  workload_identity_config {
  workload_pool = "${var.project_id}.svc.id.goog"
}

  addons_config {
    #disabling this because I'm going to install NGINX INGRESS CONTROLLER 
    http_load_balancing {
      disabled = true
    }

    horizontal_pod_autoscaling {
      disabled = false
    }
  }
}



