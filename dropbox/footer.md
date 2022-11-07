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

