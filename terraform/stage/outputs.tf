output "app_external_ip" {
  value = "${module.app.app_external_ip}"
}

output "db_internal_ip" {
  value = "${module.db.db_internal_ip}"
}

#output "app-lb_external_ip" {
#  value = "${google_compute_global_forwarding_rule.forwarding.ip_address}"
#}

