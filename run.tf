resource "google_cloud_run_v2_job" "snoozer" {
  name         = "daily-gcloud-monitoring-snooze"
  location     = "asia-northeast1"
  launch_stage = "BETA"

  template {
    template {
      volumes {
        name = "script"
        secret {
          secret = google_secret_manager_secret.script.secret_id
          items {
            version = "latest"
            path    = "script.sh"
            mode    = 256 # 0400
          }
        }
      }
      containers {
        image   = "google/cloud-sdk"
        command = ["/bin/bash", "-x"]
        args    = ["/secrets/script.sh"]
        volume_mounts {
          name       = "script"
          mount_path = "/secrets"
        }
      }
      service_account = google_service_account.job_executor.email
    }
  }

  lifecycle {
    ignore_changes = [
      launch_stage,
    ]
  }
}
