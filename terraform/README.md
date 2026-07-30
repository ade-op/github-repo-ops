# GitHub repo manager with Terraform and YAML

This repository shows a Terraform-first way to manage GitHub repositories from a YAML manifest.

## What it does

- Keep one repository definition per YAML file in [repo-configs](repo-configs)
- Use Terraform to create or update GitHub repositories
- Use the YAML filename as the GitHub repository name

## Setup

1. Install Terraform.
2. Export your GitHub token:
   ```bash
   export GITHUB_TOKEN="your_token_here"
   ```
3. Copy the example variables file and edit it:
   ```bash
   cp terraform/config/terraform.tfvars.example terraform/config/terraform.tfvars
   ```
4. Initialize Terraform:
   ```bash
   terraform -chdir=terraform/config init
   ```
5. Apply the configuration:
   ```bash
   terraform -chdir=terraform/config apply -var-file=terraform.tfvars
   ```

## How to add a repository

Add a YAML file under `terraform/repo-configs/`. The filename becomes the GitHub
repository name. For example, `terraform/repo-configs/another-repo.yaml` creates a
repository named `another-repo`:

Example:

```yaml
description: "Managed by Terraform"
private: true
visibility: "private"
topics:
  - "iac"
  - "terraform"
```

Run `terraform -chdir=terraform/config plan` or `terraform -chdir=terraform/config apply`
after adding or changing a file.
In a CI workflow, the same command can run automatically after the change is
committed.
