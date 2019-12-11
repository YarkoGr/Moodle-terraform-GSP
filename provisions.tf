resource "null_resource" "db_prov" {
  
  depends_on = ["google_compute_instance.db"]

# конект для роботи провіженерів після встановлення та налаштування ОС
  connection {
    host        = "${google_compute_instance.db.network_interface.0.access_config.0.nat_ip}"
    user        = "yarko"
    type        = "ssh"
    agent       = false
    private_key = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "file" {
    source      = "install-db.sh"
    destination = "/tmp/install-db.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-db.sh",
      "sudo -E /tmp/install-db.sh ${google_compute_instance.app.network_interface.0.network_ip}",
    ]
  }
}

resource "null_resource" "app_prov" {
  
  depends_on = ["null_resource.db_prov"]

# конект для роботи провіженерів після встановлення та налаштування ОС
  connection {
    host        = "${google_compute_instance.app.network_interface.0.access_config.0.nat_ip}"
    user        = "yarko"
    type        = "ssh"
    agent       = false
    private_key = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "file" {
    source      = "install-app.sh"
    destination = "/tmp/install-app.sh"
  }

  provisioner "remote-exec" {
   inline = [
      "chmod +x /tmp/install-app.sh",
      "sudo -E /tmp/install-app.sh ${google_compute_instance.app.network_interface.0.access_config.0.nat_ip} ${google_compute_instance.db.network_interface.0.network_ip}",
    ]
  }
}