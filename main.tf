module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "4.7.1"

  create_function = true
  function_name   = var.name
  handler         = "index.handler"
  runtime         = "nodejs16.x"
  architectures   = var.lambda_arhictecture
  timeout         = 15

  source_path = "./src"

  create_role        = true
  attach_policy_json = true
  policy_json        = data.aws_iam_policy_document.lambda_role.json

  cloudwatch_logs_retention_in_days = var.cloudwatch_logs_retention_in_days

  environment_variables = {
    BMKG_ENDPOINT       = var.bmkg_endpoint
    ANCHOR_LATITUDE     = var.anchor_latitude
    ANCHOR_LONGITUDE    = var.anchor_longitude
    ESCALATION_PLAN_ARN = var.escalation_plan_arn
    NOTIFY_RADIUS_IN_KM = var.notify_radius_in_km
    MINIMUM_SR          = var.minimum_sr
  }
}

resource "aws_iam_role" "eventbridge" {
  name               = "${var.name}-eventbridge-role"
  assume_role_policy = data.aws_iam_policy_document.eventbridge_trustpolicy.json
}

resource "aws_iam_role_policy" "eventbridge" {
  name   = "${var.name}-eventbridge-policy"
  role   = aws_iam_role.eventbridge.id
  policy = data.aws_iam_policy_document.eventbridge.json
}

resource "aws_scheduler_schedule" "example" {
  name = "my-schedule"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "rate(1 minute)"

  target {
    arn      = module.lambda.lambda_function_arn
    role_arn = aws_iam_role.eventbridge.arn

    input = "{}"
  }
}
