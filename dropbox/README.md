<!-- BEGIN_TF_DOCS -->


# Module for AWS S3 bucket with notification via SNS

This module creates the resources necessary for a S3 bucket that notifies
zero or more people through email via SNS

This module is intended to be installed via Terragrunt

Resources include but not limited to:
- S3 bucket (with logging, AES encryption, and versioning)
- SNS topic
- Notification via SNS when an object is created in the S3 bucket

<br>

#### Requirements

No requirements.

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

#### Modules

No modules.

#### Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.dropbox](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_logging.dropbox](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_notification.notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_public_access_block.dropbox](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.dropbox](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.dropbox](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_sns_topic.notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.user_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | A string describing the environment (i.e. 'dev', 'int', etc.) | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of common tags to apply to resources | `map(any)` | n/a | yes |
| <a name="input_bucket_prefix"></a> [bucket\_prefix](#input\_bucket\_prefix) | The prefix of the bucket to create | `string` | `"dropbox"` | no |
| <a name="input_email_addresses"></a> [email\_addresses](#input\_email\_addresses) | comma separated list of emails to notify for objects created in the bucket | `string` | `""` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Boolean indicating if we should force destruction to tear down the environment | `bool` | `false` | no |
| <a name="input_topic_prefix"></a> [topic\_prefix](#input\_topic\_prefix) | The prefix of the topic used for notification | `string` | `"dropbox-notification"` | no |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket"></a> [bucket](#output\_bucket) | n/a |
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | n/a |

[example]:#examples
## Examples

### Default
```hcl-terraform
provider "aws" {
  region = "us-west-2"
}

module "lambda-mongodb-rotate-pw" {
  source          = "path/to/lambda-mongodb-rotate-pw/module"
  default_tags    = { owner = "bryce@hawkeyes.org"}
  email_addresses = "bryce@hawkeyes.org"
  environment     = "dev"
  region          = "us-west-2"
  tags            = {}

```

<!-- END_TF_DOCS -->