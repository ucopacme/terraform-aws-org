# create OU hierarchy
resource "aws_organizations_organizational_unit" "managed" {
  count     = var.enabled_ous ? 1 : 0
  name      = "managed"
  parent_id = data.aws_organizations_organization.org.roots[0].id
}
resource "aws_organizations_organizational_unit" "master" {
  count     = var.enabled_ous ? 1 : 0
  name      = "master"
  parent_id = aws_organizations_organizational_unit.managed.* [0].id
}
resource "aws_organizations_organizational_unit" "member" {
  count     = var.enabled_ous ? 1 : 0
  name      = "member"
  parent_id = aws_organizations_organizational_unit.managed.* [0].id
}
resource "aws_organizations_policy_attachment" "config" {
  policy_id = aws_organizations_policy.config.id
  target_id = aws_organizations_organizational_unit.member.* [0].id
}
resource "aws_organizations_policy_attachment" "US" {
  policy_id = aws_organizations_policy.US.id
  target_id = aws_organizations_organizational_unit.member.* [0].id
}
resource "aws_organizations_organizational_unit" "test" {
  count     = var.enabled_ous ? 1 : 0
  name      = "test"
  parent_id = aws_organizations_organizational_unit.member.* [0].id
}
resource "aws_organizations_organizational_unit" "development" {
  count     = var.enabled_ous ? 1 : 0
  name      = "development"
  parent_id = aws_organizations_organizational_unit.member.* [0].id
}
resource "aws_organizations_organizational_unit" "production" {
  count     = var.enabled_ous ? 1 : 0
  name      = "production"
  parent_id = aws_organizations_organizational_unit.member.* [0].id
}
