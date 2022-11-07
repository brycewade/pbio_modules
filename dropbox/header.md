
# Module for AWS S3 bucket with notification via SNS

This module creates the resources necessary for a S3 bucket that notifies
zero or more people through email via SNS

This module is intended to be installed via Terragrunt

Resources include but not limited to:
- S3 bucket (with logging, AES encryption, and versioning)
- SNS topic
- Notification via SNS when an object is created in the S3 bucket

<br>
