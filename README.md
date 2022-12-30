# terraform-aws-bmkg-earthquake-pager

# Example
[Simple](./examples/)

```terraform
module "earthquake_pager" {
    source = "https://github.com/vincenttjia/terraform-aws-bmkg-earthquake-pager?ref=v0.0.1"

    name = "bmkg-gempa-notifier"

    # You can pick any point of interest you would like, use google maps to get the coordinates.
    # I just use the coordinates under the text of West Jakarta in Google maps.
    anchor_latitude = "-6.167435"
    anchor_longitude = "106.763709"

    notify_radius_in_km = 200
    minimum_sr = 0

    escalation_plan_arn = "arn:aws:ssm-contacts:ap-southeast-1:123456789012:contact/gempa"
}
```

# How to deploy

1. Go to this console https://ap-southeast-1.console.aws.amazon.com/systems-manager/incidents/prepare/home?region=ap-southeast-1#/ and setup AWS Incident Manager (unfortunately it's not supported in terraform yet)
2. Setup Contact details and Escalation plans
Until it shows something similar as below

![Contact details](https://github.com/vincenttjia/terraform-aws-bmkg-earthquake-pager/blob/master/images/contactDetails.png?raw=true)

to get the arn go to https://ap-southeast-1.console.aws.amazon.com/systems-manager/incidents/engagement/home?region=ap-southeast-1#/escalationplans, select your escalation plan and copy the arn as shown below

![Escalation plan](https://github.com/vincenttjia/terraform-aws-bmkg-earthquake-pager/blob/master/images/escalationPlan.png?raw=true)

3. Use the example and change the escalation plan arn, feel free to change any other variables you like

```
terraform init
```

```
terraform apply
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda"></a> [lambda](#module\_lambda) | terraform-aws-modules/lambda/aws | 4.7.1 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.eventbridge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.eventbridge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_scheduler_schedule.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule) | resource |
| [aws_iam_policy_document.eventbridge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.eventbridge_trustpolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anchor_latitude"></a> [anchor\_latitude](#input\_anchor\_latitude) | The latitude of the anchor point. | `string` | n/a | yes |
| <a name="input_anchor_longitude"></a> [anchor\_longitude](#input\_anchor\_longitude) | The longitude of the anchor point. | `string` | n/a | yes |
| <a name="input_bmkg_endpoint"></a> [bmkg\_endpoint](#input\_bmkg\_endpoint) | The endpoint for BMKG Gempa API. | `string` | `"https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json"` | no |
| <a name="input_cloudwatch_logs_retention_in_days"></a> [cloudwatch\_logs\_retention\_in\_days](#input\_cloudwatch\_logs\_retention\_in\_days) | The number of days to retain logs. | `number` | `14` | no |
| <a name="input_escalation_plan_arn"></a> [escalation\_plan\_arn](#input\_escalation\_plan\_arn) | The ARN of the escalation plan. | `string` | n/a | yes |
| <a name="input_lambda_arhictecture"></a> [lambda\_arhictecture](#input\_lambda\_arhictecture) | The architecture of the Lambda function. Valid values are x86\_64 and arm64. | `list(string)` | <pre>[<br>  "arm64"<br>]</pre> | no |
| <a name="input_minimum_sr"></a> [minimum\_sr](#input\_minimum\_sr) | The minimum SR to notify. | `number` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name for the Lambda function. | `string` | `"bmkg-gempa-notifier"` | no |
| <a name="input_notify_radius_in_km"></a> [notify\_radius\_in\_km](#input\_notify\_radius\_in\_km) | The radius in kilometer to notify. | `number` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
