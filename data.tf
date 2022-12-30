data "aws_iam_policy_document" "lambda_role" {
  statement {
    sid    = "AllowStartIncident"
    effect = "Allow"
    actions = [
      "ssm-incidents:StartIncident",
      "ssm-incidents:UpdateIncidentRecord",
      "ssm-incidents:DeleteResponsePlan",
      "ssm-incidents:CreateResponsePlan"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "eventbridge" {
  statement {
    sid    = "AllowInvokeLambda"
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = [module.lambda.lambda_function_arn]
  }
}

data "aws_iam_policy_document" "eventbridge_trustpolicy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["scheduler.amazonaws.com"]
    }
  }
}
