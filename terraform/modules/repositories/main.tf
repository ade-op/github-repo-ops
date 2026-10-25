resource "github_repository" "repos" {
  for_each = { for repo in var.repositories : repo.name => repo }

  name         = each.value.name
  description  = try(each.value.description, null)
  visibility   = try(each.value.visibility, try(each.value.private, true) ? "private" : "public")
  homepage_url = try(each.value.homepage, null)
  auto_init    = try(each.value.auto_init, true)
  topics       = try(each.value.topics, [])
  has_issues   = true
  has_projects = false
  has_wiki     = false
}

resource "github_branch_protection" "repos" {
  for_each = {
    for repo in var.repositories : repo.name => repo
    if try(repo.branch_protection, null) != null
  }

  repository_id  = each.key
  pattern        = try(each.value.branch_protection.pattern, "main")
  enforce_admins = true

  dynamic "required_status_checks" {
    for_each = try(each.value.branch_protection.required_status_checks, null) == null ? [] : [each.value.branch_protection.required_status_checks]

    content {
      strict   = try(required_status_checks.value.strict, true)
      contexts = try(required_status_checks.value.contexts, [])
    }
  }

  dynamic "required_pull_request_reviews" {
    for_each = try(each.value.branch_protection.required_pull_request_reviews, null) == null ? [] : [each.value.branch_protection.required_pull_request_reviews]

    content {
      required_approving_review_count = try(required_pull_request_reviews.value.required_approving_review_count, 1)
    }
  }
}
