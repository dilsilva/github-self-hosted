<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_repository.ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_key_pair.keypair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_ssm_parameter.pat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | n/a | `any` | n/a | yes |
| <a name="input_pat_value"></a> [pat\_value](#input\_pat\_value) | n/a | `any` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | n/a | `any` | n/a | yes |
| <a name="input_public_key"></a> [public\_key](#input\_public\_key) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecr_repository"></a> [ecr\_repository](#output\_ecr\_repository) | The URL of the repository (in the form aws\_account\_id.dkr.ecr.region.amazonaws.com/repositoryName). |
| <a name="output_key_pair_arn"></a> [key\_pair\_arn](#output\_key\_pair\_arn) | The ARN of the key for the EC2 |
| <a name="output_key_pair_name"></a> [key\_pair\_name](#output\_key\_pair\_name) | The name of the key for the EC2 |
| <a name="output_ssm_parameter_name"></a> [ssm\_parameter\_name](#output\_ssm\_parameter\_name) | The value of the parameter. |
<!-- END_TF_DOCS -->