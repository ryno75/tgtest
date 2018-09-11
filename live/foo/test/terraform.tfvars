# Foo conf
terragrunt = {
  terraform {
    source = "git::git@github.com:ryno75/tgtest//modules/test"
    extra_arguments "foo_args" {
      commands = ["${get_terraform_commands_that_need_vars()}"]
      arguments = [
        "-var", "mod_parent_folder=${find_in_parent_folders()}",
        "-var", "mod_get_tfvars_dir=${get_tfvars_dir()}",
        "-var", "mod_get_parent_tfvars_dir=${get_parent_tfvars_dir()}",
      ]
      env_vars = {
        TF_VAR_leaf_name = "foo"
      }
    }
  }

  include {
      path = "${find_in_parent_folders()}"
  }
}

env    = "foo"
region = "us-east-1"
