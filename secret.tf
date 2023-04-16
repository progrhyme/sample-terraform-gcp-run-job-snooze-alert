resource "google_secret_manager_secret" "script" {
  secret_id = "script-daily-gcloud-monitoring-snooze"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "script" {
  secret      = google_secret_manager_secret.script.name
  secret_data = file("${path.module}/script.sh")
}
