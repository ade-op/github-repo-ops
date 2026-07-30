resource "github_repository" "repos" {
  for_each = { for repo in var.repositories : repo.name => repo }

  name         = each.value.name
  description  = try(each.value.description, null)
  visibility   = try(each.value.visibility, "private")
  private      = try(each.value.private, true)
  homepage_url = try(each.value.homepage, null)
  auto_init    = try(each.value.auto_init, true)
  topics       = try(each.value.topics, [])
  has_issues   = true
  has_projects = false
  has_wiki     = false
}
