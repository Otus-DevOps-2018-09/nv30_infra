resource "google_compute_instance" "app" {
  name         = "reddit-app-${var.env}"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"
  tags         = ["reddit-app"]

  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  network_interface {
    network = "default"

    access_config = {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }
}

resource "null_resource" "app" {
  count = "${var.deploy_app}"

  triggers {
    build_number = "${timestamp()}"
  }

  connection {
    type        = "ssh"
    host        = "${google_compute_address.app_ip.address}"
    user        = "appuser"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {
    content     = "${data.template_file.puma_service.rendered}"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "../modules/app/files/deploy.sh"
  }
}

data "template_file" "puma_service" {
  template = "${file("${path.module}/files/puma.service")}"

  vars {
    database_ip = "${var.database_ip}"
  }
}

resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip-${var.env}"
}

resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default-${var.env}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["reddit-app"]
}
