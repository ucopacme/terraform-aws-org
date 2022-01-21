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

# full scp, allow everything
resource "aws_organizations_policy" "full" {
  content     = <<POLICY
{
  "Statement": {
    "Action": "*",
    "Effect": "Allow",
    "Resource": "*",
    "Sid": "full"
  },
  "Version": "2012-10-17"
}
POLICY
  description = "access to everything"
  name        = "full"
  tags        = var.tags
  type        = "SERVICE_CONTROL_POLICY"
}

# US regions scp, allow only US regions for all services except for global
# services
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
                "budgets:*",
                "cloudfront:*",
                "globalaccelerator:*",
                "iam:*",
                "importexport:*",
                "organizations:*",
                "route53:*",
                "support:*",
                "waf:*"
            ],
            "Resource": "*",
            "Sid": "OnlyMurica"
        }
    ],
    "Version": "2012-10-17"
}
POLICY
  description = "Make AWS Great Again USA, USA, USA, USA restriction"
  name        = "regions"
  tags        = var.tags
  type        = "SERVICE_CONTROL_POLICY"
}
