resource "google_compute_instance" "db" {
  name         = "db"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags = ["db"]

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
        nat_ip = ""
      }
    }

  metadata = {
    ssh-keys = "yarko:${file("~/.ssh/id_rsa")}"
  }  
}