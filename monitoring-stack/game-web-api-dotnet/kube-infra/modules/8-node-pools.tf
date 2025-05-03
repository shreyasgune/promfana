# resource "google_service_account" "kubernetes" {
#   account_id   = "${var.region}-kubernetes"
#   display_name = "Kubernetes Engine Service Account"
#   project      = var.project_id

# }


resource "google_container_node_pool" "general" {
  name       = "${var.region}-general"
  cluster    = google_container_cluster.primary.id
  node_count = var.initial_node_count

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = false
    machine_type = var.node_machine_type
    labels = {
      "role" = "${var.region}-general"
    }

    service_account = var.google_service_account
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "google_container_node_pool" "spot" {
  name    = "${var.region}-spot"
  cluster = google_container_cluster.primary.id

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = var.autoscaling_min_node_count
    max_node_count = var.autoscaling_max_node_count
  }

  node_config {
    preemptible = true
    # A note about premptible VMs: they are not guaranteed to be available. If you have a workload that can tolerate a VM being terminated at any time, then you can use this. If you have a workload that needs to be available all the time, then you should not use this. This uses cheaper VMs for the k8s nodes. They last upto 24hrs. They're good for batch jobs, but not for long running services.
    machine_type = var.node_machine_type

    labels = {
      "role" = "${var.region}-spot"
    }

    #The taint is meant to avoid accidental scheduling. Your deployment or Pod objects must tolerate those taints. 
    # A taint is a key-value pair that is applied to a node in a Kubernetes cluster.
    # A toleration is a pod-level attribute that allows a pod to tolerate (i.e., be scheduled onto) nodes with matching taints.
    # A taint is applied to a node.
    # Pods without matching tolerations are not scheduled onto nodes with the corresponding taint.
    # Pods with matching tolerations can be scheduled onto nodes with the corresponding taint.
    # If multiple taints are present on a node, a pod must have matching tolerations for all of them to be scheduled onto that node.
    taint {
      key    = "instance_type"
      value = "spot"
      effect = "NO_SCHEDULE"

    }

    service_account = var.google_service_account
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}