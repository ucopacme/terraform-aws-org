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
    parent_id      = string
    tags = object({
      ucopapplication        = string,
      ucopavailability_level = string,
      ucopprotection_level   = string,
      ucopenvironment        = string,
      ucopbusiness_contact   = string,
      ucopservice            = string,
      ucopservice_owner      = string,
      ucoptechnical_contact  = string,
    })
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


