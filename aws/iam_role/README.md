Define policies and roles for example:

```
locals {
  policies = {
    custom_policy = {
      name        = "custom_policy"
      description = "custom policy created by terraform program"
      policy = templatefile("path/policy.json", {
        var_name = var_value
      }
    }
  }

  roles = {
    role = {
      name               = "name"
      description        = "description"
      assume_role_policy = "path/policy.json"
      create_profile     = true
      attach_policies = {
        managed = {
          "name" = "AWS managed role ARN"
        }
        custom = {
          "custom_policy" = local.policies.custom_policy.name
        }
      }
    }
  }
}
```

Create polciy and roles:
```
resource "aws_iam_policy" "policy" {
  for_each    = local.policies
  name        = each.value.name
  description = each.value.description
  policy      = each.value.policy
}

module "roles" {
  source                         = "git@github.com:NadavOps/terraform.git//aws/iam_role"
  for_each                       = local.roles
  role_name                      = each.value.name
  role_description               = each.value.description
  force_detach_policies          = true
  create_profile                 = each.value.create_profile
  trust_relationship_policy      = each.value.assume_role_policy
  path                           = "/"
  tags                           = {}

  aws_managed_policies    = contains(keys(each.value.attach_policies), "managed") ? each.value.attach_policies.managed : {}
  custom_managed_policies = contains(keys(each.value.attach_policies), "custom") ? each.value.attach_policies.custom : {}

  depends_on = [aws_iam_policy.policy]
}
```