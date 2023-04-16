resource "google_service_account" "job_executor" {
  account_id = "run-job-monitoring-snoozer"
}

resource "google_project_iam_member" "job_executor_edit_snooze" {
  project = data.google_project.project.project_id
  role    = "roles/monitoring.snoozeEditor"
  member  = google_service_account.job_executor.member
}

resource "google_cloud_run_v2_job_iam_member" "job_executor_run_snoozer" {
  project  = google_cloud_run_v2_job.snoozer.project
  location = google_cloud_run_v2_job.snoozer.location
  name     = google_cloud_run_v2_job.snoozer.name
  role     = "roles/run.invoker"
  member   = google_service_account.job_executor.member
}

resource "google_secret_manager_secret_iam_member" "job_executor_read_script" {
  secret_id = google_secret_manager_secret.script.id
  role      = "roles/secretmanager.secretAccessor"
  member    = google_service_account.job_executor.member
  depends_on = [
    google_secret_manager_secret.script,
    google_service_account.job_executor,
  ]
}
