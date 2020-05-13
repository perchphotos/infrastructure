provider "aws" {}

variable "churps_bucket" { type = string }

resource "aws_s3_bucket" "churp" {
  bucket = var.churps_bucket
  acl    = "private"
}
