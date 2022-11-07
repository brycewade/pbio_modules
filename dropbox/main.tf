locals {
  aws_acct_id = data.aws_caller_identity.current.id
  region      = data.aws_region.current.id
  bucket_name = format("%s-%s-%s-%s", var.bucket_prefix, var.environment, local.region, local.aws_acct_id)
  topic_name  = format("%s-%s", var.topic_prefix, var.environment)
}

# First create the bucket.  
resource "aws_s3_bucket" "dropbox" {
  bucket = local.bucket_name
  tags = merge(
    var.tags,
    { "Name" = local.bucket_name },
  )
  force_destroy = var.force_destroy
}

# Turning on versioning is generally a good idea.
resource "aws_s3_bucket_versioning" "dropbox" {
  bucket = aws_s3_bucket.dropbox.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Let's start with AES256 enryption for the MVP, we should switch to KMS in a
# later upgrade
resource "aws_s3_bucket_server_side_encryption_configuration" "dropbox" {
  bucket = aws_s3_bucket.dropbox.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Add logging in case we ever need to so some forensic work
# TODO:  This assumes the bucket already exists, create module that will
# create these regional logging buckets
resource "aws_s3_bucket_logging" "dropbox" {
  bucket        = aws_s3_bucket.dropbox.id
  target_bucket = "s3-access-logs-${local.region}-${local.aws_acct_id}"
  target_prefix = format("%s/", local.bucket_name)
}

# Let's make sure we done allow public access to this bucket.  If we change
# our minds later we will likely want to use https anyway, so that means
# using CloudFront, so this still holds.
resource "aws_s3_bucket_public_access_block" "dropbox" {
  bucket                  = aws_s3_bucket.dropbox.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Let's set up the policy for the SNS topic.  Allow S3 to publish to the
# topic, but only if it is coming from our bucket.
data "aws_iam_policy_document" "notification" {
  statement {
    actions = [
      "SNS:Publish"
    ]
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    resources = [
      format("arn:aws:sns:%s:%s:%s", local.region, local.aws_acct_id, local.topic_name)
    ]
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.dropbox.arn]
    }
    sid = "AllowNotification"
  }
}

# Create the SNS topic we are going to use for notification
resource "aws_sns_topic" "notification" {
  name   = local.topic_name
  policy = data.aws_iam_policy_document.notification.json
  tags = merge(
    var.tags,
    { "Name" = local.topic_name },
  )
}

# TODO: Look into using SQS instead of SNS to aggregate multiple files
# into one email to prevent mail floods.
resource "aws_s3_bucket_notification" "notification" {
  bucket = aws_s3_bucket.dropbox.id

  topic {
    topic_arn = aws_sns_topic.notification.arn
    events    = ["s3:ObjectCreated:*"]
  }
}

# Take a comma separated list of email addresses and subscribe each
# of them tot he topic (they will still have to confirm the subscription)
# TODO: Send email via Lambda with much more user friendly formatting
resource "aws_sns_topic_subscription" "user_notification" {
  for_each  = toset(split(",", var.email_addresses))
  endpoint  = each.key
  protocol  = "email"
  topic_arn = aws_sns_topic.notification.arn
}
