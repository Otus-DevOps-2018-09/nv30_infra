variable public_key_path {
  description = "Path to the public key used to connect to instance"
}

variable zone {
  description = "Zone"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}

variable machine_type {
  description = "Machine type for reddit db instance"
  default     = "g1-small"
}

variable env {
  description = "Environment type"
  default = ""
}
