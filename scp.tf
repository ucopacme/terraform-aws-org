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

# security services scp, prevent disable or deletion of GuardDuty,
# Security Hub, Detective, etc.
resource "aws_organizations_policy" "securityservices" {
  content     = <<POLICY
{
  "Statement": {
    "Action": [
      "guardduty:AcceptAdministratorInvitation",
      "guardduty:DisableOrganizationAdminAccount",
      "guardduty:UpdateOrganizationConfiguration",
      "organizations:CreateOrganization",
      "organizations:DeleteOrganization",
      "securityhub:AcceptAdministratorInvitation",
      "securityhub:DisableOrganizationAdminAccount",
      "securityhub:UpdateOrganizationConfiguration"
    ],
    "Effect": "Deny",
    "Resource": "*",
    "Sid": "SecurityServicesLock"
  },
  "Version": "2012-10-17"
}
POLICY
  description = "security services lock"
  name        = "securityservices"
  tags        = var.tags
  type        = "SERVICE_CONTROL_POLICY"
}

# resource restrict scp, prevent creation of exorbitant cost
# resources (huge provisioned IOPS EBS, etc.)
resource "aws_organizations_policy" "resourcerestrict" {
  content     = <<POLICY
{
  "Statement": {
    "Condition": {
      "NumericGreaterThan": {
        "ec2:VolumeIops": "7000"
      }
    },
    "Action": [
      "ec2:CreateVolume",
      "ec2:ModifyVolume"
    ],
    "Effect": "Deny",
    "Resource": "*",
    "Sid": "EbsIopsRestriction"
  },
  "Version": "2012-10-17"
}
POLICY
  description = "resource restrictions"
  name        = "resourcerestrict"
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
# The DenyUSEast2AndUSWest1Regions block allows some exceptions for principals
# which we want (for now) to at least allow access to these regions within
# the limits of their identity-based policies.  For example, this allows
# AWSReservedSSO_rw or AWSReservedSSO_ro users' read-only access to Ohio and
# N. California to still work.  This is intended to permit access for legacy
# reference and lingering light usage of these two regions that does not
# involve deploying new resources.  The need for this is probably minimal
# and will expire over time.
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
            "Sid": "DenyNonUSRegions"
        },
        {
            "Condition": {
                "StringEquals": {
                    "aws:RequestedRegion": [
                        "us-east-2",
                        "us-west-1"
                    ]
                },
                "ArnNotLike": {
                    "aws:PrincipalARN": [
                        "arn:aws:iam::*:role/CloudCustodian*",
                        "arn:aws:iam::*:role/DatadogIntegrationRole",
                        "arn:aws:iam::*:role/aws-reserved/sso.amazonaws.com/us-west-2/AWSReservedSSO_finops_*",
                        "arn:aws:iam::*:role/aws-reserved/sso.amazonaws.com/us-west-2/AWSReservedSSO_full_*",
                        "arn:aws:iam::*:role/aws-reserved/sso.amazonaws.com/us-west-2/AWSReservedSSO_ro_*",
                        "arn:aws:iam::*:role/aws-reserved/sso.amazonaws.com/us-west-2/AWSReservedSSO_rw_*",
                        "arn:aws:iam::*:role/awsauth/service/guardduty/ManageGuardDuty*",
                        "arn:aws:iam::229341609947:user/awsauth/*",
                        "arn:aws:iam::280181752709:role/awsauth/fdw-prodRO",
                        "arn:aws:iam::497286016891:role/aws-serverless-repository-StandardRedirectsForClou-12P1MJZ9MXH6Y",
                        "arn:aws:iam::613074250484:role/awsauth/fdw-devRO",
                        "arn:aws:iam::944706592399:role/MaillerRole"
                    ]
                }
            },
            "Effect": "Deny",
            "NotAction": [
                "support:*"
            ],
            "Resource": "*",
            "Sid": "DenyUSEast2AndUSWest1Regions"
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
