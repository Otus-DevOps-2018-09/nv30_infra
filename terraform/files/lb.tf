resource "google_compute_instance_group" "app-cluster" {
  name        = "reddit-app-cluster"
  description = "Instance group for reddit-app"

  instances = [
    "${google_compute_instance.app.*.self_link}",
  ]

  named_port {
    name = "puma-http"
    port = "9292"
  }

  zone = "${var.zone}"
}

resource "google_compute_health_check" "app-heartbit" {
  name               = "reddit-app-heartbit"
  check_interval_sec = 2
  timeout_sec        = 2

  tcp_health_check {
    port = "9292"
  }
}

resource "google_compute_backend_service" "app-lb" {
  name             = "reddit-app-lb"
  protocol         = "HTTP"
  port_name        = "puma-http"
  timeout_sec      = 10
  session_affinity = "NONE"

  backend {
    group = "${google_compute_instance_group.app-cluster.self_link}"
  }

  health_checks = ["${google_compute_health_check.app-heartbit.self_link}"]
}

resource "google_compute_url_map" "app-url-map" {
  name            = "reddit-app-url-map"
  default_service = "${google_compute_backend_service.app-lb.self_link}"
}

resource "google_compute_target_http_proxy" "app-proxy" {
  name    = "reddit-app-proxy"
  url_map = "${google_compute_url_map.app-url-map.self_link}"
}

resource "google_compute_global_forwarding_rule" "forwarding" {
  name       = "app-forwarding-rule"
  target     = "${google_compute_target_http_proxy.app-proxy.self_link}"
  port_range = "80"
}
