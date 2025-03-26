provider "google" {
  project = "${var.project_id}"
  region  = var.location
}

variable "location" {
  description = "GCP Location for Cloud Function"
}

variable "project_id" {
  description = "GCP Project ID"
}

resource "google_compute_instance" "default" {
  name         = "test-instance"
  machine_type = "n2-standard-2"
  zone         = "us-central1-c"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }




  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = "517443832736-compute@developer.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}

# Allow HTTP traffic
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["34.49.246.127/32"]
  target_tags   = ["foo", "bar"]
}

# Allow HTTPS traffic
resource "google_compute_firewall" "allow_https" {
  name    = "allow-https"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = [google_compute_global_address.default.address]
  target_tags   = ["foo", "bar"]
}

# Allow Load Balancer Health Checks
resource "google_compute_firewall" "allow_health_checks" {
  name    = "allow-health-checks"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16",
    "108.170.220.0/23",
    "108.170.221.0/24"
  ]
  target_tags   = ["foo", "bar"]
}


resource "google_compute_instance_group" "webservers" {
  name        = "test-webservers"
  description = "Terraform test instance group"

  instances = [
    google_compute_instance.default.id,
  ]

  named_port {
    name = "http"
    port = "80"
  }

  zone = "us-central1-c"
}


# Create a Global HTTP Load Balancer
resource "google_compute_global_address" "default" {
  name = "testelb"
}

# Backend Service using the Instance Group
resource "google_compute_backend_service" "default" {
  name          = "test-backend-service"
  health_checks = [google_compute_health_check.default.id]

  backend {
    group = google_compute_instance_group.webservers.id
  }
}

# Health Check for the Backend
resource "google_compute_health_check" "default" {
  name = "test-health-check"

  tcp_health_check {
    port = 80
  }
}

# URL Map (Default Routing)
resource "google_compute_url_map" "default" {
  name            = "test-url-map"
  default_service = google_compute_backend_service.default.id
}

# Target HTTP Proxy
resource "google_compute_target_http_proxy" "default" {
  name    = "test-target-proxy"
  url_map = google_compute_url_map.default.id
}

# Global Forwarding Rule (Frontend)
resource "google_compute_global_forwarding_rule" "default" {
  name       = "test-forwarding-rule"
  target     = google_compute_target_http_proxy.default.id
  port_range = "80"
  ip_address = google_compute_global_address.default.address
}
