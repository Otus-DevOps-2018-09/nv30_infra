resource "google_compute_instance" "db" {
  name         = "reddit-db-${var.env}"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"
  tags         = ["reddit-db"]

  boot_disk {
    initialize_params {
      image = "${var.db_disk_image}"
    }
  }

  network_interface {
    network       = "default"
    access_config = {}
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
}

resource "null_resource" "db" {
  count = "${var.deploy_app}"

  triggers {
    build_number = "${timestamp()}"
  }

  connection {
    type        = "ssh"
    host        = "${google_compute_instance.db.network_interface.0.access_config.0.nat_ip}"
    user        = "appuser"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf",
      "sudo systemctl restart mongod",
    ]
  }
}

resource "google_compute_firewall" "firewall_mongo" {
  name    = "allow-mongo-default-${var.env}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }

  # правило применимо к инстансам с тегом ...
  target_tags = ["reddit-db"]

  # порт будет доступен только для инстансов с тегом ...
  source_tags = ["reddit-app"]
}

resource "google_compute_address" "internal_ip" {
  name         = "reddit-db-${var.env}-internal-ip"
  address_type = "INTERNAL"
}
