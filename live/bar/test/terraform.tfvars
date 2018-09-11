terragrunt = {
  terraform {
    source = "git::git@github.com:ryno75/tgtest//modules/test"
    include {
      path = "${find_in_parent_folders()}"
    }
  }
}

env = "bar"
