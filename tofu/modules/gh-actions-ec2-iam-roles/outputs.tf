output "ec2_deploy_plan_role_arn" {
  value = length(aws_iam_role.ec2_deploy_plan) > 0 ? aws_iam_role.ec2_deploy_plan[0].arn : null
}

# output "lambda_deploy_apply_role_arn" {
#   value = length(aws_iam_role.lambda_deploy_apply) > 0 ? aws_iam_role.lambda_deploy_apply[0].arn : null
# }
