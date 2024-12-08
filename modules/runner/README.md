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
| [aws_autoscaling_group.runner_auto_scaling_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_iam_instance_profile.runner_host_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.runner_host_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.runner_host_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.runner_host](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_template.runner_launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_lb.runner_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.runner_lb_listener_22](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.runner_lb_target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_route53_record.runner_record_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.private_instances_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.runner_host_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.all_egress_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.egress_runner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.lb_runner_ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.shh_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ami.ubuntu-linux-2404](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.runner_host_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | n/a | `bool` | `false` | no |
| <a name="input_auto_scaling_group_subnets"></a> [auto\_scaling\_group\_subnets](#input\_auto\_scaling\_group\_subnets) | List of subnets where the Auto Scaling Group will deploy the instances | `list(string)` | n/a | yes |
| <a name="input_aws_ecs_cluster_name"></a> [aws\_ecs\_cluster\_name](#input\_aws\_ecs\_cluster\_name) | Name of the ECS Cluster where the operations gonna be executed | `string` | `""` | no |
| <a name="input_aws_ecs_service_name"></a> [aws\_ecs\_service\_name](#input\_aws\_ecs\_service\_name) | Name of the ECS service where the operations gonna be executed | `string` | `""` | no |
| <a name="input_cidrs"></a> [cidrs](#input\_cidrs) | List of CIDRs that can access the runner. Default: 0.0.0.0/0 | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_create_dns_record"></a> [create\_dns\_record](#input\_create\_dns\_record) | Choose if you want to create a record name for the runner (LB). If true, 'hosted\_zone\_id' and 'runner\_record\_name' are mandatory | `bool` | n/a | yes |
| <a name="input_create_elb"></a> [create\_elb](#input\_create\_elb) | Choose if you want to deploy an ELB for accessing runner hosts. If true, you must set elb\_subnets and is\_lb\_private | `bool` | `true` | no |
| <a name="input_disk_encrypt"></a> [disk\_encrypt](#input\_disk\_encrypt) | Instance EBS encryption | `bool` | `true` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | Root EBS size in GB | `number` | `100` | no |
| <a name="input_elb_subnets"></a> [elb\_subnets](#input\_elb\_subnets) | List of subnets where the ELB will be deployed | `list(string)` | `[]` | no |
| <a name="input_enable_instance_metadata_tags"></a> [enable\_instance\_metadata\_tags](#input\_enable\_instance\_metadata\_tags) | Enables or disables access to instance tags from the instance metadata service | `bool` | `false` | no |
| <a name="input_github_owner"></a> [github\_owner](#input\_github\_owner) | GitHub repository owner. | `string` | `""` | no |
| <a name="input_github_repo"></a> [github\_repo](#input\_github\_repo) | GitHub repository name. | `string` | `""` | no |
| <a name="input_github_runner_group"></a> [github\_runner\_group](#input\_github\_runner\_group) | Custom GitHub runner group. | `string` | `""` | no |
| <a name="input_github_runner_labels"></a> [github\_runner\_labels](#input\_github\_runner\_labels) | Custom GitHub runner labels. <br>Example: `"gpu,x64,linux"`. | `string` | `""` | no |
| <a name="input_github_url"></a> [github\_url](#input\_github\_url) | GitHub full URL.<br>Example: "https://github.com/cloudandthings/repo". | `string` | `""` | no |
| <a name="input_hosted_zone_id"></a> [hosted\_zone\_id](#input\_hosted\_zone\_id) | Name of the hosted zone where we'll register the runner DNS name | `string` | `""` | no |
| <a name="input_http_endpoint"></a> [http\_endpoint](#input\_http\_endpoint) | Whether the metadata service is available | `bool` | `true` | no |
| <a name="input_http_put_response_hop_limit"></a> [http\_put\_response\_hop\_limit](#input\_http\_put\_response\_hop\_limit) | The desired HTTP PUT response hop limit for instance metadata requests | `number` | `1` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance size of the runner | `string` | `"t3.nano"` | no |
| <a name="input_ipv4_cidr_block"></a> [ipv4\_cidr\_block](#input\_ipv4\_cidr\_block) | List of ipv4 CIDR blocks from the subnet | `list(string)` | <pre>[<br/>  ""<br/>]</pre> | no |
| <a name="input_is_lb_private"></a> [is\_lb\_private](#input\_is\_lb\_private) | If TRUE, the load balancer scheme will be "internal" else "internet-facing" | `bool` | `null` | no |
| <a name="input_private_ssh_port"></a> [private\_ssh\_port](#input\_private\_ssh\_port) | Set the SSH port to use between the runner and private instance | `number` | `22` | no |
| <a name="input_project"></a> [project](#input\_project) | Name of the project | `string` | `"surepay"` | no |
| <a name="input_public_ssh_port"></a> [public\_ssh\_port](#input\_public\_ssh\_port) | Set the SSH port to use from desktop to the runner | `number` | `22` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_runner_additional_security_groups"></a> [runner\_additional\_security\_groups](#input\_runner\_additional\_security\_groups) | List of additional security groups to attach to the launch template | `list(string)` | `[]` | no |
| <a name="input_runner_ami"></a> [runner\_ami](#input\_runner\_ami) | The AMI that the runner Host will use. | `string` | `""` | no |
| <a name="input_runner_host_key_pair"></a> [runner\_host\_key\_pair](#input\_runner\_host\_key\_pair) | Select the key pair to use to launch the runner host | `string` | n/a | yes |
| <a name="input_runner_iam_policy_name"></a> [runner\_iam\_policy\_name](#input\_runner\_iam\_policy\_name) | IAM policy name to create for granting the instance role access to the bucket | `string` | `"runnerHost"` | no |
| <a name="input_runner_iam_role_name"></a> [runner\_iam\_role\_name](#input\_runner\_iam\_role\_name) | IAM role name to create | `string` | `"runnerRole"` | no |
| <a name="input_runner_instance_count"></a> [runner\_instance\_count](#input\_runner\_instance\_count) | n/a | `number` | `1` | no |
| <a name="input_runner_instance_count_max"></a> [runner\_instance\_count\_max](#input\_runner\_instance\_count\_max) | n/a | `number` | `3` | no |
| <a name="input_runner_instance_count_min"></a> [runner\_instance\_count\_min](#input\_runner\_instance\_count\_min) | n/a | `number` | `1` | no |
| <a name="input_runner_launch_template_name"></a> [runner\_launch\_template\_name](#input\_runner\_launch\_template\_name) | runner Launch template Name, will also be used for the ASG | `string` | `"runner-lt"` | no |
| <a name="input_runner_record_name"></a> [runner\_record\_name](#input\_runner\_record\_name) | DNS record name to use for the runner | `string` | `""` | no |
| <a name="input_runner_security_group_id"></a> [runner\_security\_group\_id](#input\_runner\_security\_group\_id) | Custom security group to use | `string` | `""` | no |
| <a name="input_ssm_parameter_name"></a> [ssm\_parameter\_name](#input\_ssm\_parameter\_name) | SSM parameter name for the GitHub Runner token.<br>Example: "/github/runner/token". | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign | `map(string)` | `{}` | no |
| <a name="input_use_imds_v2"></a> [use\_imds\_v2](#input\_use\_imds\_v2) | Use (IMDSv2) Instance Metadata Service V2 | `bool` | `false` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where we'll deploy the runner | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_elb_arn"></a> [elb\_arn](#output\_elb\_arn) | The ARN of the ELB for runner hosts |
| <a name="output_elb_ip"></a> [elb\_ip](#output\_elb\_ip) | The DNS name of the ELB for runner hosts |
| <a name="output_private_instances_security_group"></a> [private\_instances\_security\_group](#output\_private\_instances\_security\_group) | The ID of the security group for private instances |
| <a name="output_runner_auto_scaling_group_name"></a> [runner\_auto\_scaling\_group\_name](#output\_runner\_auto\_scaling\_group\_name) | The name of the Auto Scaling Group for runner hosts |
| <a name="output_runner_elb_id"></a> [runner\_elb\_id](#output\_runner\_elb\_id) | The ID of the ELB for runner hosts |
| <a name="output_runner_host_security_group"></a> [runner\_host\_security\_group](#output\_runner\_host\_security\_group) | The ID of the runner host security group |
| <a name="output_target_group_arn"></a> [target\_group\_arn](#output\_target\_group\_arn) | The ARN of the target group for the ELB |
<!-- END_TF_DOCS -->