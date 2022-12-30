module "earthquake_pager" {
  source = "../"

  name = "bmkg-gempa-notifier"

  # You can pick any point of interest you would like, use google maps to get the coordinates.
  # I just use the coordinates under the text of West Jakarta in Google maps.
  anchor_latitude  = "-6.167435"
  anchor_longitude = "106.763709"

  notify_radius_in_km = 200
  minimum_sr          = 0

  escalation_plan_arn = "arn:aws:ssm-contacts:ap-southeast-1:123456789012:contact/gempa"
}
