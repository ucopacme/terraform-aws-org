# cloudtrail scp prevent deletion, stopping or updating of cloudtrail in accounts
resource "aws_organizations_policy" "cloudtrail" {
  content     = <<POLICY
{
  "Statement": {
    "Action": [
      "cloudtrail:StopLogging",
      "cloudtrail:DeleteTrail",
      "cloudtrail:UpdateTrail"
    ],
    "Effect": "Deny",
    "Resource": "*",
    "Sid": "CloudTrailLock"
  },
  "Version": "2012-10-17"
}
POLICY
  description = "cloudtrail lock"
  name        = "cloudtrail"
  tags        = var.tags
  type        = "SERVICE_CONTROL_POLICY"
}

# config scp, prevent deletion of config in accounts
resource "aws_organizations_policy" "config" {
  content     = <<POLICY
{
  "Statement": {
    "Action": [
      "config:DeleteConfigRule",
      "config:DeleteConfigurationRecorder",
      "config:DeleteDeliveryChannel",
      "config:StopConfigurationRecorder"
    ],
    "Effect": "Deny",
    "Resource": "*",
    "Sid": "ConfigLock"
  },
  "Version": "2012-10-17"
}
POLICY
  description = "config lock"
  name        = "config"
  tags        = var.tags
  type        = "SERVICE_CONTROL_POLICY"
}

#
# US regions scp: allow only US regions for all services.
# Since us-east-1 is in our allowed list, we need not be precise or exhaustive
# in listing exceptions for global services (us-east-1 is the default endpoint
# for these). But out of abundance of caution, we still list an exception for
# organizations:* and support:*.
# Reference:
# https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_examples_aws_deny-requested-region.html
#
resource "aws_organizations_policy" "US" {
  content     = <<POLICY
{
    "Statement": [
        {
            "Condition": {
                "StringNotEquals": {
                    "aws:RequestedRegion": [
                        "us-east-1",
                        "us-east-2",
                        "us-west-1",
                        "us-west-2"
                    ]
                }
            },
            "Effect": "Deny",
            "NotAction": [
                "organizations:*",
                "support:*"
            ],
            "Resource": "*",
            "Sid": "DenyRegions"
        }
    ],
    "Version": "2012-10-17"
}
POLICY
  description = "Deny usage of non-US regions"
  name        = "regions"
  tags        = var.tags
  type        = "SERVICE_CONTROL_POLICY"
}
