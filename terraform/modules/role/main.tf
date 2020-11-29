//resource "aws_iam_instance_profile" "test_profile" {
//  name = "test_profile"
//  role = aws_iam_role.cloud_watch_server_agent.name
//}

resource "aws_iam_role" "cloud_watch_server_agent" {
  name = "cloud_watch_server_agent"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    Name    = "cloud_watch_server_agent"
    env     = "${var.env}"
    region  = "${var.aws_region}"
    Service = "${var.project_name}"
  }
}

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.cloud_watch_server_agent.name
}


//resource "aws_iam_role" "cloud_watch_server_agent" {
//  name = "cloud_watch_server_agent"
//
//  assume_role_policy = <<EOF
//{
//    "Version": "2012-10-17",
//    "Statement": [
//        {
//            "Effect": "Allow",
//            "Action": [
//                "cloudwatch:PutMetricData",
//                "ec2:DescribeVolumes",
//                "ec2:DescribeTags",
//                "logs:PutLogEvents",
//                "logs:DescribeLogStreams",
//                "logs:DescribeLogGroups",
//                "logs:CreateLogStream",
//                "logs:CreateLogGroup"
//            ],
//            "Resource": "*"
//        },
//        {
//            "Effect": "Allow",
//            "Action": [
//                "ssm:GetParameter"
//            ],
//            "Resource": "arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"
//        }
//    ]
//}
//EOF
//
//  tags = {
//    Name    = "cloud_watch_server_agent"
//    env     = "${var.env}"
//    region  = "${var.aws_region}"
//    Service = "${var.project_name}"
//  }
//}