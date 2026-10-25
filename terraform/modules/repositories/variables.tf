variable "repositories" {
  description = "List of repository definitions to manage"
  type = list(object({
    name        = string
    description = optional(string)
    visibility  = optional(string)
    private     = optional(bool)
    homepage    = optional(string)
    auto_init   = optional(bool)
    topics      = optional(list(string), [])

    branch_protection = optional(object({
      pattern = optional(string, "main")

      required_status_checks = optional(object({
        strict   = optional(bool, true)
        contexts = optional(list(string), [])
      }))

      required_pull_request_reviews = optional(object({
        required_approving_review_count = optional(number, 1)
      }))
    }))
  }))
}
