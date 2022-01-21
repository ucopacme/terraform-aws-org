# Organization
Our organization is the AWS EDP (enterprise discount plan) organization

##  ![Organization Unit Structure](notes/ou-ucop.png)

### root
all accounts in EDP org

### unmanaged
un managed account in EDP org, no scps

### managed
all ucop managed accounts in EDP org

### master
EDP org master account

### member
non master ucop managed accounts

### test
test OU for testing org features ucop managed accounts like scp, tag policies, new rules, etc

### development
non production ucop managed accounts

### production
production ucop managed accounts

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider_aws) | n/a |

#### Modules

No modules.

#### Inputs

| Name | Description | Type |
|------|-------------|------|
| <a name="input_name"></a> [name](#input_name) | Resource name | `string` |
| <a name="input_test_accounts"></a> [test_accounts](#input_test_accounts) | map of managed accounts | <pre>map(object({<br>    email          = string,<br>    billing_access = string,<br>    name           = string,<br>    ou             = string,<br>    tags = object({<br>      ucopapplication        = string,<br>      ucopavailability_level = string,<br>      ucopprotection_level   = string,<br>      ucopenvironment        = string,<br>      ucopbusiness_contact   = string,<br>      ucopservice            = string,<br>      ucopservice_owner      = string,<br>      ucoptechnical_contact  = string,<br>    })<br>    })<br>  )</pre> |
| <a name="input_enabled_ous"></a> [enabled_ous](#input_enabled_ous) | to create Organization OUs | `bool` |
| <a name="input_tags"></a> [tags](#input_tags) | A map of tags to add to all resources | `map(string)` |
