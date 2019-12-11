resource "google_compute_firewall" "firewall_ssh" {
name    = "default-allow-ssh"
network = "default"
target_tags = ["db", "app"]
source_tags = ["db", "app"]

    allow {
        protocol = "tcp"
        ports    = ["22", "3306"]
    }
    allow {
    protocol = "icmp"
  }
    source_ranges = ["0.0.0.0/0"]
}