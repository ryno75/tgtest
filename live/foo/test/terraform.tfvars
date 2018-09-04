terragrunt = {
  terraform {
    source = "git::git@github.com:ryno75/tgtest.git//modules/test"
    include {
      path = "${find_in_parent_folders()}"
    }
  }
}

env = "foo"
