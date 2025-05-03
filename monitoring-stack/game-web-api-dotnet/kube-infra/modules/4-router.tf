# This is used to advertise routes. It will be used with NAT gateway to allow VMs without public IP to access the internet. (for example, to download packages or docker images from docker hub)


resource "google_compute_router" "router" {
  name    = "${var.region}-router"
  network = google_compute_network.main.id
  region  = var.region
}