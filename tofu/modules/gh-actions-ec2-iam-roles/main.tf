resource "aws_iam_role" "ec2_deploy_plan" {
  count              = var.enable_iam_role_for_ec2_plan ? 1 : 0
  name               = "${var.name}-plan"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_for_ec2_plan[0].json
}

data "aws_iam_policy_document" "assume_role_policy_for_ec2_plan" {
  count = var.enable_iam_role_for_ec2_plan ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      identifiers = [var.oidc_provider_arn]
      type        = "Federated"
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_repo}:*"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "plan_ec2_app" {
  count  = var.enable_iam_role_for_ec2_plan ? 1 : 0
  role   = aws_iam_role.ec2_deploy_plan[0].id
  policy = data.aws_iam_policy_document.plan_ec2_app[0].json
}

data "aws_iam_policy_document" "plan_ec2_app" {
  count = var.enable_iam_role_for_ec2_plan ? 1 : 0

  statement {
    sid    = "IamReadOnlyPermissions"
    effect = "Allow"
    actions = [
      "iam:List*Role*",
      "iam:Get*Role*"
    ]
    resources = ["arn:aws:iam::*:role/${var.ec2_base_name}*"]
  }

  statement {
    sid       = "EC2ReadOnlyPermissions"
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }

  statement {
    sid       = "ElasticLoadBalancingReadOnlyPermissions"
    effect    = "Allow"
    actions   = ["elasticloadbalancing:Describe*"]
    resources = ["*"]
  }

  statement {
    sid       = "CloudWatchReadOnlyPermissions"
    effect    = "Allow"
    actions   = ["cloudwatch:ListMetrics", "cloudwatch:GetMetricStatistics", "cloudwatch:Describe*"]
    resources = ["*"]
  }

  statement {
    sid       = "AutoScalingReadOnlyPermissions"
    effect    = "Allow"
    actions   = ["autoscaling:Describe*"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "ec2_deploy_apply" {
  count = var.enable_iam_role_for_ec2_apply ? 1 : 0

  name               = "${var.name}-apply"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_for_ec2_apply[0].json
}

data "aws_iam_policy_document" "assume_role_policy_for_ec2_apply" {
  count = var.enable_iam_role_for_ec2_apply ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      identifiers = [var.oidc_provider_arn]
      type        = "Federated"
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_repo}:ref:refs/heads/main"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "apply_ec2_app" {
  count  = var.enable_iam_role_for_ec2_apply ? 1 : 0
  role   = aws_iam_role.ec2_deploy_apply[0].id
  policy = data.aws_iam_policy_document.apply_ec2_app[0].json
}

data "aws_iam_policy_document" "apply_ec2_app" {
  count = var.enable_iam_role_for_ec2_apply ? 1 : 0

  statement {
    sid    = "IamPermissions"
    effect = "Allow"
    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:UpdateRole",
      "iam:PassRole",
      "iam:List*Role*",
      "iam:Get*Role*"
    ]
    resources = ["arn:aws:iam::*:role/${var.ec2_base_name}*"]
  }

  statement {
    sid       = "EC2DescribePermissions"
    effect    = "Allow"
    actions   = ["ec2:DescribeInstances", "ec2:DescribeImages", "ec2:DescribeInstanceTypes", "ec2:DescribeKeyPairs", "ec2:DescribeVpcs", "ec2:DescribeSubnets", "ec2:DescribeSecurityGroups"]
    resources = ["*"]
  }

  statement {
    sid       = "KeyAndSGCreatePermissions"
    effect    = "Allow"
    actions   = ["ec2:CreateSecurityGroup", "ec2:AuthorizeSecurityGroupIngress", "ec2:CreateKeyPair"]
    resources = ["*"]
  }

  statement {
    sid       = "RunEC2Permissions"
    effect    = "Allow"
    actions   = ["ec2:RunInstances"]
    resources = ["*"]
  }
}