terraform {
  backend "gcs" {}
}

variable "gcp_project" {}
variable "gcp_region" {}

provider "google" {
  project     = "${var.gcp_project}"
  region      = "${var.gcp_region}"
}

variable "master_uri" {}
variable "grid_token" {}
variable "docker_opts" {}

module "kontena_node_ignition" {
  source = "github.com/kontena/kontena-terraform-modules/modules/node-ignition"
  master_uri = "${var.master_uri}"
  grid_token = "${var.grid_token}"
  docker_opts = "${var.docker_opts}"
}

resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "n1-standard-1"
  zone         = "us-west1-a"

  tags = ["foo", "bar"]

  disk {
    image = "coreos-cloud/coreos-stable"
  }

  network_interface {
    network = "default"

    access_config {
    }
  }

  metadata {
     user-data = "${module.kontena_node_ignition.rendered}"
  }

  metadata_startup_script = "echo hi > /test.txt"

}

output "ignition" {
  value = "${module.kontena_node_ignition.rendered}"
}
