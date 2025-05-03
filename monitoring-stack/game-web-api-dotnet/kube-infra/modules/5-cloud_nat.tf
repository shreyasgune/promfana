resource "google_compute_router_nat" "nat" {
  name                               = "${var.region}-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.private.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

resource "google_compute_address" "nat" {
  name         = "nat"
  region       = var.region
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"

  depends_on = [google_project_service.compute]
}







###

# GCP Cloud NAT (Network Address Translation) is a service provided by Google Cloud Platform (GCP) that allows you to perform network address translation for your virtual machine (VM) instances. It enables instances without public IP addresses to access the internet, and provides a way to manage outbound connections from private instances.

# Here's how GCP Cloud NAT works:

# Private IP Instances: In GCP, you can create virtual machine instances with private IP addresses. These instances are not directly accessible from the internet.

# Cloud NAT Configuration: To enable internet connectivity for private instances, you configure Cloud NAT. This involves creating a Cloud NAT gateway, which acts as a virtual router and performs network address translation.

# NAT Gateway: The Cloud NAT gateway resides in a subnet and has an associated public IP address. It acts as an intermediary between the private instances and the internet. The gateway performs source NAT, replacing the private IP addresses of outgoing packets with its own public IP address.

# Route Configuration: To direct traffic through the Cloud NAT gateway, you configure routes. You specify a destination range and point it to the Cloud NAT gateway's IP address. This ensures that traffic destined for the internet from the private instances is routed through the NAT gateway.

# Outbound Connectivity: When a private instance sends traffic to the internet, the traffic is routed through the Cloud NAT gateway. The gateway replaces the private source IP address with its own public IP address, allowing the response traffic from the internet to be directed back to the NAT gateway.

# Session Persistence: Cloud NAT maintains session persistence, ensuring that responses from the internet are correctly mapped to the private instances that initiated the traffic.

# Billing: Cloud NAT has associated costs based on the egress (outbound) data processed by the NAT gateway. It is billed per gigabyte of processed data.

# Cloud NAT provides the following benefits:

# Outbound Connectivity: It allows private instances to connect to the internet without requiring public IP addresses.

# Security: By not assigning public IP addresses to instances, Cloud NAT helps protect them from direct exposure to the internet.

# Scalability: Cloud NAT can handle a high volume of outbound connections, making it suitable for large-scale deployments.

# Simplified Network Configuration: Cloud NAT eliminates the need for complex network configurations, such as configuring Network Address Translation Protocol (NAT) on individual instances.

# Integration with other GCP Services: Cloud NAT seamlessly integrates with other GCP services, such as Compute Engine and Virtual Private Cloud (VPC) networks.

# Note that Cloud NAT only supports outbound connections. Ingress (incoming) connections from the internet to private instances still require other mechanisms, such as load balancers or VPNs, depending on your specific requirements.