provider "google" {
  credentials = "${file("IT-clusret-projekt-ba4804662de4.json")}"
  project = "it-cluster-project"
  region  = "${var.region}"
}