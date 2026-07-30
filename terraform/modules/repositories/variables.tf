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
  }))
}
