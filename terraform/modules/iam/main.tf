// Setting an Account Password Policy for IAM Users
// https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_passwords_account-policy.html?icmpid=docs_iam_console
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_account_password_policy
resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 8
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = false
  require_symbols                = true
  allow_users_to_change_password = true
  password_reuse_prevention = 2
  max_password_age = 90
}
// devops group
resource "aws_iam_user" "devops" {
  count         = "${length(var.devops_user_names)}"
  name          = "${element(var.devops_user_names, count.index)}"
  force_destroy = false
  tags = {
    Name = "iam_u.onwer:cjub.oh"
  }
}
resource "aws_iam_group" "devops" {
  name = "devops"
}
resource "aws_iam_user_group_membership" "devops" {
  count = "${length(var.devops_user_names)}"
  groups = ["${aws_iam_group.devops.name}"]
  user = "${element(var.devops_user_names, count.index)}"
}

resource "aws_iam_group_policy_attachment" "devops_access" {
  group = "${aws_iam_group.devops.id}"
  policy_arn = "${var.devops_policy_arn}"
}
// developers group
resource "aws_iam_user" "developer" {
  count         = "${length(var.developer_user_names)}"
  name          = "${element(var.developer_user_names, count.index)}"
  force_destroy = false
  tags = {
    Name = "iam_u.onwer:cjub.oh"
  }
}
resource "aws_iam_group" "developers" {
  name = "developers"
}
resource "aws_iam_user_group_membership" "developers" {
  count = "${length(var.developer_user_names)}"
  groups = ["${aws_iam_group.developers.name}"]
  user = "${element(var.developer_user_names, count.index)}"
}

resource "aws_iam_group_policy_attachment" "developers_access" {
  group = "${aws_iam_group.developers.id}"
  policy_arn = "${var.developers_policy_arn}"
}
resource "aws_iam_group_policy_attachment" "user_change_password_policy" {
  group = "${aws_iam_group.developers.id}"
  policy_arn = "${var.user_change_password_policy_arn}"
}
// circle ci users
resource "aws_iam_user" "circleci" {
  count         = "${length(var.circleci_user_names)}"
  name          = "${element(var.circleci_user_names, count.index)}"
  force_destroy = false
  tags = {
    Name = "iam_user_developers"
  }
}
resource "aws_iam_user_policy" "circleci" {
  name = "iam_access_policy_for_circleci"
  count = "${length(var.circleci_user_names)}"
  user = "${element(aws_iam_user.circleci.*.name, count.index)}"
  policy = "${data.aws_iam_policy_document.circleci.json}"
}
// etl users
resource "aws_iam_user" "etl" {
  count         = "${length(var.etl_user_names)}"
  name          = "${element(var.etl_user_names, count.index)}"
  force_destroy = false
  tags = {
    Name = "iam_user_developers"
  }
}
resource "aws_iam_user_policy" "etl" {
  name = "iam_access_policy_for_etl"
  count = "${length(var.etl_user_names)}"
  user = "${element(aws_iam_user.etl.*.name, count.index)}"
  policy = "${data.aws_iam_policy_document.etl.json}"
}
data "aws_iam_policy_document" "circleci" {
  # S3 Full Access for Deploy
  statement {
    actions   = ["s3:*"]
    effect    = "Allow"
    resources = [
      "arn:aws:s3:::deploy-stg-maps",
      "arn:aws:s3:::deploy-stg-maps/*"
    ]
  }
}
data "aws_iam_policy_document" "etl" {
  # S3 Full Access for ETL
  statement {
    actions   = ["s3:*"]
    effect    = "Allow"
    resources = [
      "arn:aws:s3:::etl-stg-maps",
      "arn:aws:s3:::etl-stg-maps/*"
    ]
  }
}

resource "aws_iam_policy" "cloudwatch_read_only" {
  name = "cloudwatch-read-only"
  policy = "${data.aws_iam_policy_document.cloudwatch_read_only.json}"
}

data "aws_iam_policy_document" "cloudwatch_read_only" {
  statement {
    effect = "Allow"
    actions = ["cloudwatch:Describe*", "cloudwatch:Ge*", "cloudwatch:List*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cloudwatch_full_access" {
  name = "cloudwatch-full-access"
  policy = "${data.aws_iam_policy_document.cloudwatch_full_access.json}"
}

data "aws_iam_policy_document" "cloudwatch_full_access" {
  statement {
    effect = "Allow"
    actions = ["Cloudwatch:*"]
    resources = ["*"]
  }
}