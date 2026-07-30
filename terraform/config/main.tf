terraform {
  required_version = ">= 1.5.0"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}

locals {
  repo_config_files = fileset("${path.module}/../repo-configs", "*.yaml")

  repos = [
    for config_file in local.repo_config_files : merge(
      yamldecode(file("${path.module}/../repo-configs/${config_file}")),
      {
        name = trimsuffix(basename(config_file), ".yaml")
      }
    )
  ]
}

module "repositories" {
  source = "../modules/repositories"

  repositories = local.repos
}
