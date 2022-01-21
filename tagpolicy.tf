resource "aws_organizations_policy" "tag_policy" {
  content     = file("${path.module}/policies/tag_policy.json")
  description = "Required tagging policy"
  name        = "required-tagging-rules"
  tags        = var.tags
  type        = "TAG_POLICY"
}

resource "aws_organizations_policy_attachment" "tag_policy_attach" {
  policy_id = aws_organizations_policy.tag_policy.id
  target_id = aws_organizations_organizational_unit.test[0].id
}
