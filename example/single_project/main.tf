variable networking_project {}
provider "google-beta" {}

locals {
  name       = "gke-private-example"
  project    = "${var.networking_project}"
  region     = "us-east1"
  zone1      = "us-east1-c"
  zone2      = "us-east1-b"
}

resource "google_compute_network" "gke-private" {
  name                    = "${local.name}"
  project                 = "${local.project}"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "gke-private1" {
  name          = "${local.name}"
  region        = "${local.region}"
  project       = "${local.project}"
  network       = "${google_compute_network.gke-private.id}"
  ip_cidr_range = "10.1.0.0/16"

  secondary_ip_range {
    range_name    = "gke-private-services"
    ip_cidr_range = "10.101.0.0/16"
  }

  secondary_ip_range {
    range_name    = "gke-private-pods"
    ip_cidr_range = "10.201.0.0/16"
  }

  private_ip_google_access = "true"
}

resource "google_compute_router" "router" {
  name    = "${local.name}"
  region  = "${local.region}"
  project = "${local.project}"
  network = "${google_compute_network.gke-private.id}"

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat1" {
  name                               = "${local.name}"
  project                            = "${local.project}"
  router                             = "${google_compute_router.router.name}"
  region                             = "${local.region}"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

module "kube_region1" {
  source         = "../../"
  name           = "gke-private"
  network        = "${google_compute_network.gke-private.self_link}"
  subnetwork     = "${google_compute_subnetwork.gke-private1.self_link}"
  project        = "${local.project}"
  location       = "${local.region}"
  node_locations = ["${local.zone1}", "${local.zone2}"]
  cluster_range  = "gke-private-pods"
  services_range = "gke-private-services"
  manc           = {
    "World" : "0.0.0.0/0"
  }
  enable_psp     = "false"
}