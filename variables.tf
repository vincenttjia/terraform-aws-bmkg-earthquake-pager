variable "name" {
  type        = string
  description = "The name for the Lambda function."
  default     = "bmkg-gempa-notifier"
}

variable "bmkg_endpoint" {
  type        = string
  description = "The endpoint for BMKG Gempa API."
  default     = "https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json"
}

variable "anchor_latitude" {
  type        = string
  description = "The latitude of the anchor point."
}

variable "anchor_longitude" {
  type        = string
  description = "The longitude of the anchor point."
}

variable "escalation_plan_arn" {
  type        = string
  description = "The ARN of the escalation plan."
}

variable "notify_radius_in_km" {
  type        = number
  description = "The radius in kilometer to notify."
}

variable "minimum_sr" {
  type        = number
  description = "The minimum SR to notify."
}

variable "cloudwatch_logs_retention_in_days" {
  type        = number
  description = "The number of days to retain logs."
  default     = 14
}

variable "lambda_arhictecture" {
  type        = list(string)
  description = "The architecture of the Lambda function. Valid values are x86_64 and arm64."
  default     = ["arm64"]
}
