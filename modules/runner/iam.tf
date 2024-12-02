resource "aws_iam_instance_profile" "runner_instance_profile" {
  name = "runner_instance_profile"
  role = aws_iam_role.github_actions_assume_role.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Apply Least Privilege ASAP
data "aws_iam_policy_document" "runner_policy" {
  statement {
    actions   = ["ec2:ReplaceIamInstanceProfileAssociation", "ec2:AssociateIamInstanceProfile"]
    resources = ["*"]
  }
  statement {
    actions   = ["iam:PassRole"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "runner_policy" {
  name   = "runner_policy"
  role   = aws_iam_role.github_actions_assume_role.id
  policy = data.aws_iam_policy_document.runner_policy.json
}

resource "aws_iam_role" "github_actions_assume_role" {
  name               = "github_actions_assume_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}