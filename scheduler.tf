resource "google_cloud_scheduler_job" "job" {
  name             = "daily-gcloud-monitoring-snooze"
  description      = "Invoke Cloud Run Job \"daily-gcloud-monitoring-snooze\" daily"
  schedule         = "0 13 * * *"
  time_zone        = "Asia/Tokyo"
  attempt_deadline = "300s"
  region           = "asia-northeast1"
  project          = data.google_project.project.project_id

  retry_config {
    retry_count = 3
  }

  http_target {
    http_method = "POST"
    uri         = "https://${google_cloud_run_v2_job.snoozer.location}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${data.google_project.project.number}/jobs/${google_cloud_run_v2_job.snoozer.name}:run"

    oauth_token {
      service_account_email = google_service_account.job_executor.email
    }
  }

  depends_on = [
    google_cloud_run_v2_job.snoozer,
    google_cloud_run_v2_job_iam_member.job_executor_run_snoozer,
  ]
}
