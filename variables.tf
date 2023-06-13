variable "enabled_ous" {
  type        = bool
  description = "to create Organization OUs"
  default     = false
}
variable "accounts" {
  description = "map of managed accounts"
  type = map(object({
    email          = string,
    billing_access = string,
    name           = string,
    ou             = string,
    parent_id      = string,
    tags           = map(string)
    })
  )
}

variable "name" {
  description = "Resource name"
  type        = string
}
variable "tags" {
  default     = {}
  description = "A map of tags to add to all resources"
  type        = map(string)
}


