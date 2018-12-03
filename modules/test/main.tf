provider "aws" {
  version = "1.32.0"
  profile = "ietest"
  region  = "${var.region}"
}

terraform {
  backend "s3" {}
}

module "meta" {
  source            = "git::ssh://git@github.hq.smartsheet.com/CloudOps/tfm_aws_meta.git"
  application       = "Foo"
  app_role          = "Bar"
  customer_facing   = "false"
  department        = "160-TechOps"
  environment       = "${var.leaf}"
  owner             = "infra.eng.sre@smartsheet.com"
  project           = "Nimbus"
  tf_state_bucket   = "com.smartsheet.ietst.terraform"
  tf_state_key      = "brawndo_test.tfstate"
  tf_module_repo    = "https://github.com/ryno75/tgtest.git/modules/test"
  tf_module_version = "0.0.0"
  tg_repo           = "https://github.com/ryno75/tgtest.git"
}

locals {
  extra_tags = {
    md5sum                 = "${md5(module.meta.nugget)}"
    root_pr_to_include     = "${var.root_pr_to_include}"
    root_pr_from_include   = "${var.root_pr_from_include}"
    root_tfvars_dir        = "${var.root_get_tfvars_dir}"
    root_parent_tfvars_dir = "${var.root_get_parent_tfvars_dir}"
    aws_account_id         = "${var.root_get_aws_account_id}"
    mod_parent_folder      = "${var.mod_parent_folder}"
    mod_tfvars_dir         = "${var.mod_get_tfvars_dir}"
    mod_parent_tfvars_dir  = "${var.mod_get_parent_tfvars_dir}"
  }
}

resource "aws_s3_bucket" "brawndo_test" {
  bucket = "${var.bucket_prefix}-${var.project}-${var.leaf}"
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
