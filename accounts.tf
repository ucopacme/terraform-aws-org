# make  accounts from object of  accounts defined in accounts
resource "aws_organizations_account" "test-accounts" {
  for_each                   = var.accounts
  email                      = each.value.email
  iam_user_access_to_billing = each.value.billing_access
  name                       = each.value.name
  # parent_id                  = aws_organizations_organizational_unit.test.* [0].id
  parent_id = each.value.parent_id
  tags      = each.value.tags
}

# resource "aws_iam_account_alias" "alias" {
#   for_each = var.accounts
#   account_alias = "${each.value.name}-ucop"
# }
