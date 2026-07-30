output "repository_names" {
  description = "Names of the repositories managed by this module"
  value       = [for repo in github_repository.repos : repo.name]
}
