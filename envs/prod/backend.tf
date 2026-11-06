# envs/prod/backend.tf
terraform {
  backend "s3" {
    bucket       = "novasphere-tfstate-naf"
    key          = "novasphere/prod/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
