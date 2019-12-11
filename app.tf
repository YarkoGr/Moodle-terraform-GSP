resource "google_compute_instance" "app" {
  name         = "app"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags = ["app"]

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }
  network_interface {
    # мережа до якої приєднати даний інтерфес
    network = "default"
    # використовувати ephemeral IP для доступа з інтернет
    access_config {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }

  metadata = {
    ssh-keys = "yarko:${file("~/.ssh/id_rsa")}"
  }    
}
resource "google_compute_address" "app_ip" {
name = "reddit-app-ip"
}
resource "google_compute_firewall" "firewall_app" {
  name = "allow-app-default"
  # назва мережі в якій діє правило
  network = "default"
  # який доступ дозволити
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  allow {
    protocol = "icmp"
  }
  # Яким адресам дозволити доступ
  source_ranges = ["0.0.0.0/0"]
  # правило застосовується для інстансів з такими тегами
  target_tags = ["app"]
}