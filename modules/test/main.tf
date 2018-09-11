variable "bucket_prefix" {}
variable "env" {}
variable "root_pr_to_include" {}
variable "root_pr_from_include" {}
variable "root_get_tfvars_dir" {}
variable "root_get_parent_tfvars_dir" {}

provider "aws" {
  version = "1.32.0"
  profile = "ietest"
  region  = "us-east-1"
}

module "meta" {
  source            = "git::ssh://git@github.hq.smartsheet.com/CloudOps/tfm_aws_meta.git"
  version           = "0.1.0"
  application       = "Foo"
  app_role          = "Bar"
  customer_facing   = "false"
  department        = "160-TechOps"
  environment       = "${var.env}"
  owner             = "infra.eng.sre@smartsheet.com"
  project           = "Nimbus"
  shutdown_behavior = "always_on"
  tf_state_bucket   = "com.smartsheet.pipeline.dev.terraform"
  tf_state_key      = "brawndo_test.tfstate"
  tf_lock_table     = "com.smartsheet.pipeline.dev.terraform-lock-table"
  tf_repo           = "git::ssh://git@github.hq.smartsheet.com/CloudOps/foo.git"
}

locals {
  extra_tags = {
    md5sum                     = "${md5(module.meta.nugget)}"
    root_pr_to_include         = "${var.root_pr_to_include}"
    root_pr_from_include       = "${var.root_pr_from_include}"
    root_get_tfvars_dir        = "${var.root_get_tfvars_dir}"
    root_get_parent_tfvars_dir = "${var.root_get_parent_tfvars_dir}"
  }
}

resource "aws_s3_bucket" "brawndo_test" {
  bucket = "${var.bucket_prefix}-${var.env}"
  acl    = "private"
  tags   = "${merge(module.meta.tags, local.extra_tags)}"
}

module "arpdoc" {
  source  = "git::ssh://git@github.hq.smartsheet.com/CloudOps/tfm_aws_iam_arpdoc.git"
  version = "0.1.1"
  service = "lambda"
}

resource "aws_s3_bucket_object" "brawndo_test" {
  bucket  = "${aws_s3_bucket.brawndo_test.id}"
  key     = "${module.meta.nugget}"
  content = "${module.arpdoc.json}"

  #tags = "${merge(module.meta.tags, local.extra_tags)}"
}
