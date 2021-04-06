# Filename: main.tf
# Configure GCP project
provider "google" {
  project = "public-apps-282115"
}
# Deploy image to Cloud Run
resource "google_cloud_run_service" "webapp1" {
  name     = "web"
  location = "us-central1"
  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}
# Create public access
data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}
# Enable public access on Cloud Run service
resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.webapp1.location
  project     = google_cloud_run_service.webapp1.project
  service     = google_cloud_run_service.webapp1.name
  policy_data = data.google_iam_policy.noauth.policy_data
}
# Return service URL
output "url" {
  value = google_cloud_run_service.webapp1.status[0].url
}