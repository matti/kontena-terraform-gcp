output "ignition_i" {
  value = "${module.kontena_node_ignition_i.rendered}"
}

module "kontena_node_ignition_i" {
  source = "github.com/kontena/kontena-terraform-modules/modules/node-ignition"
  master_uri = "${var.master_uri}"
  grid_token = "${var.grid_token}"
  docker_opts = "${var.docker_opts}"
}

resource "google_compute_instance_template" "i" {
  disk {
    boot = true
    source_image = "coreos-cloud/coreos-stable"
    disk_type = "pd-ssd"
    disk_size_gb = 9
  }

  machine_type = "n1-standard-1"
  region       = "${var.gcp_region}"

  metadata {
     user-data = "${module.kontena_node_ignition_i.rendered}"
  }

  network_interface {
    network = "default"

    access_config = {}
  }

  scheduling {
    on_host_maintenance = "MIGRATE"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance_group_manager" "i" {
  base_instance_name = "i"
  instance_template  = "${google_compute_instance_template.i.self_link}"
  name               = "i"
  zone               = "us-west1-a"
}

resource "google_compute_autoscaler" "i" {
  name   = "i"
  target = "${google_compute_instance_group_manager.i.self_link}"
  zone   = "us-west1-a"

  autoscaling_policy = {
    max_replicas    = 1
    min_replicas    = 1

    cpu_utilization {
      target = 1
    }
  }


}
