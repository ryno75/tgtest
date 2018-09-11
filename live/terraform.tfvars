# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
terragrunt = {
  # Configure root level variables that all resources can inherit
  terraform {
    extra_arguments "commons" {
      commands = ["${get_terraform_commands_that_need_vars()}"]
      arguments = [
        "-var", "root_pr_to_include=${path_relative_to_include()}",
        "-var", "root_pr_from_include=${path_relative_from_include()}",
        "-var", "root_get_tfvars_dir=${get_tfvars_dir()}",
        "-var", "root_get_parent_tfvars_dir=${get_parent_tfvars_dir()}",
        "-var", "root_get_aws_account_id=${get_aws_account_id()}",
      ]
      optional_var_files = [
        "${get_parent_tfvars_dir()}/common.tfvars}"
      ]
    }
  }
}

