# Foo conf
terragrunt = {
  terraform {
    source = "git::git@github.com:ryno75/tgtest//modules/test"
    extra_arguments "foo_args" {
      commands = ["${get_terraform_commands_that_need_vars()}"]
      arguments = [
        "-var", "mod_pr_to_include=${path_relative_to_include()}",
        "-var", "mod_pr_from_include=${path_relative_from_include()}",
        "-var", "mod_parent_folder=${find_in_parent_folders()}",
        "-var", "mod_get_tfvars_dir=${get_tfvars_dir()}",
        "-var", "mod_get_parent_tfvars_dir=${get_parent_tfvars_dir()}",
      ]
    }
  }

  include {
      path = "${find_in_parent_folders()}"
  }
}

env = "foo"
