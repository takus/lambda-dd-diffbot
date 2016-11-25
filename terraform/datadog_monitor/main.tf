resource "datadog_monitor" "diffbot_api_limit" {
  name = "[Diffbot] API limits"

  type = "query alert"
  query = "max(last_5m): 100 * max:diffbot.monthlyCalls{*} / max:diffbot.monthlyPlanCalls{*} > 95.0"
  message = "${var.message}"
  include_tags = true

  thresholds {
    critical = "95.0"
	warning = "75.0"
  }

  notify_no_data = true
  no_data_timeframe = 60
  require_full_window = false

  renotify_interval = 360

  notify_audit = false
}
