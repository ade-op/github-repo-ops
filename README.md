# GitHub Repository Operations

Manage GitHub repositories as code with Terraform and YAML configuration files.
Each YAML file in `terraform/repo-configs/` describes one repository, and its
filename becomes the GitHub repository name.

## How it works

1. Add or update a repository manifest in `terraform/repo-configs/`.
2. Terraform reads the manifests and passes them to the reusable repository
   module in `terraform/modules/repositories/`.
3. GitHub Actions validates the YAML and Terraform configuration, then creates
   a plan.
4. Successful changes merged to `main` can be applied by the deployment workflow.

The repository uses HCP Terraform for remote state in the
`ade-op/github-repo-ops` workspace.

## Prerequisites

- Terraform `1.5.0` or newer
- A GitHub personal access token with permission to manage repositories
- A GitHub user or organization where repositories should be created

## Local usage

From the repository root, copy the example variables file and set your values:

```bash
cp terraform/config/terraform.tfvars.example terraform/config/terraform.tfvars
```

Then initialize and run Terraform:

```bash
terraform -chdir=terraform/config init
terraform -chdir=terraform/config plan
terraform -chdir=terraform/config apply
```

Terraform prompts for `github_token` and `github_owner` if they are not set in
`terraform.tfvars`. Keep local variable files and tokens out of version control.

## Repository manifest format

Create a file such as `terraform/repo-configs/example-repository.yaml`:

```yaml
description: "Managed by Terraform"
private: true
visibility: "private"
homepage: ""
auto_init: true
topics:
  - "terraform"
  - "github"
```

Supported fields are:

- `description` — repository description
- `private` — whether the repository is private
- `visibility` — `public`, `private`, or `internal`
- `homepage` — optional homepage URL
- `auto_init` — whether GitHub initializes the repository
- `topics` — list of repository topics

Use either `private` or `visibility` consistently. If both are provided, they
must describe the same visibility.

## GitHub Actions configuration

Configure these repository or organization settings for CI and deployment:

- `GH_PAT` secret — GitHub token used by Terraform
- `REPOSITORY_OWNER` variable — GitHub username or organization name
- `TF_TOKEN_APP_TERRAFORM_IO` secret — HCP Terraform API token

`Terraform CI` runs on pushes and pull requests. It checks formatting, validates
the YAML manifests, validates Terraform, and generates a plan. `Terraform
Deploy` applies changes after a successful CI run on `main`, or when manually
started with `workflow_dispatch`.

## Project layout

```text
terraform/
├── config/                 # Root Terraform configuration
├── modules/repositories/   # Reusable GitHub repository resource
└── repo-configs/           # YAML repository manifests
.github/workflows/          # CI and deployment workflows
```
