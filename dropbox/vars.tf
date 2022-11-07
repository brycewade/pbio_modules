variable "bucket_prefix" {
  type        = string
  description = "The prefix of the bucket to create"
  default     = "dropbox"
}

variable "email_addresses" {
  type        = string
  description = "comma separated list of emails to notify for objects created in the bucket"
  default     = ""
}

variable "environment" {
  type        = string
  description = "A string describing the environment (i.e. 'dev', 'int', etc.)"
}

variable "force_destroy" {
  type        = bool
  description = "Boolean indicating if we should force destruction to tear down the environment"
  default     = false
}

variable "tags" {
  type        = map(any)
  description = "A map of common tags to apply to resources"
}

variable "topic_prefix" {
  type        = string
  description = "The prefix of the topic used for notification"
  default     = "dropbox-notification"
}
