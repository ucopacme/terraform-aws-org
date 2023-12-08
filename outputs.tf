output "aaa-org" {
  value = data.aws_organizations_organization.org
}
output "aaa-ou" {
  value = data.aws_organizations_organizational_units.ou
}
output "managed_ou" {
  value = aws_organizations_organizational_unit.managed
}
output "master_ou" {
  value = aws_organizations_organizational_unit.master
}
output "test_ou" {
  value = aws_organizations_organizational_unit.test
}
output "development_ou" {
  value = aws_organizations_organizational_unit.development
}
output "production_ou" {
  value = aws_organizations_organizational_unit.production
}
output "spr_ou" {
  value = aws_organizations_organizational_unit.spr
}
