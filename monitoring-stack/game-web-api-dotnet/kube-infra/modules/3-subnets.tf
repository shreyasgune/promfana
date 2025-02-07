resource "google_compute_subnetwork" "private" {
  name                     = "${var.region}-private"
  ip_cidr_range            = var.ip_cidr_range # 16384 addresses, 16382 usable
  region                   = var.region
  network                  = google_compute_network.main.id
  private_ip_google_access = true

  # k8s nodes will use IPs from the main CIDR range, but pods will use IPs from this secondary range, in case you need to open firewall access to other VMs in your VPC from K8s, and setthis as the source range along with a gke Service account
  secondary_ip_range {
    range_name    = "k8s-pods-range"
    ip_cidr_range = var.pod_ip_cidr_range
  }

  secondary_ip_range {
    range_name    = "k8s-services-range"
    ip_cidr_range = var.service_ip_cidr_range
  }

}