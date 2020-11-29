resource "aws_sns_topic" "alarm" {
  name = "alarms-topic"
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF

  provisioner "local-exec" {
//    command = "aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.alarms_email} --no-verify-ssl"
    command = "aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.alarms_email}"
  }
}
//data "aws_instance" "example" {
//  instance_id = "${var.instance_id}"
//  filter {
//    name = "image-id"
//    values = ["ami-05466daab6a2abe63"]
//  }
//
//  filter {
//    name = "tag:Name"
//    values = ["instance-name-tag"]
//  }
//}
//resource "aws_key_pair" "ssh" {
//  key_name   = "default"
//  public_key = file("~/.ssh/id_rsa.pub")
//}
resource "aws_cloudwatch_dashboard" "starter-dashboard" {
//    dashboard_name = "dashboard-${var.ec2-instance}"
//  dashboard_name = "dashboard-i-0956581d2db31e840q"
  dashboard_name = "dashboard-${var.instance_id}"

  dashboard_body = <<EOF
  {
    "widgets": [
      {
        "type" : "metric",
        "x":0,
        "y":0,
        "width":12,
        "height":6,
        "properties": {
          "metrics": [
            [
              "AWS/EC2",
              "CPUUtilization",
              "InstanceId",
              "${var.instance_id}"
            ]
          ],
          "period":300,
          "stat":"Average",
          "region": "ap-northeast-2",
          "title":"${var.instance_id}- CPU Utilization"
        }
      },
      {
        "type":"text",
        "x":0,
        "y":7,
        "width":3,
        "height":3,
        "properties":{
          "markdown":"some text"
        }
      },
      {
        "type": "metric",
        "x": 0,
        "y": 0,
        "width": 12,
        "height": 6,
        "properties":{
          "metrics":[
            [
              "AWS/EC2",
              "NetworkIn",
              "InstanceId",
              "${var.instance_id}"
            ]
          ],
          "period":300,
          "stat":"Average",
          "region":"ap-northeast-2",
          "title":"${var.instance_id} - NetworkIn"
        }
      }
    ]
  }
  EOF
}

resource "aws_cloudwatch_metric_alarm" "cpu-alarm" {
  alarm_name = "terraform-test-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  //  metric_name = "CPUCreditBalance"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Average"
  threshold = 2
  alarm_description = "This metric monitors when ec2 cpu utiliation reaches 80%"
  alarm_actions = ["${aws_sns_topic.alarm.arn}"]
  //  insufficient_data_actions = []
  insufficient_data_actions = ["${aws_sns_topic.alarm.arn}"]
  dimensions = {
    //    InstanceId = aws_instance.web.id
    InstanceId = "${var.instance_id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "health-alarm" {
  alarm_name = "terraform-test-health-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "StatusCheckFailed"
  //  metric_name = "CPUCreditBalance"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Average"
  threshold = "2"
  alarm_description = "This metric monitors when ec2 ec2 health status"
  alarm_actions = ["${aws_sns_topic.alarm.arn}"]
  //  insufficient_data_actions = []
  insufficient_data_actions = ["${aws_sns_topic.alarm.arn}"]
  dimensions = {
    //    InstanceId = aws_instance.web.id
    InstanceId = "${var.instance_id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "test-metric-healthy-elb" {
  alarm_name = "test-metric-healthy-elb"
  alarm_description = "This alarm will be created but not attached to an ELB."
  metric_name = "HealthyHostCount"
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold = "2"
  statistic = "Minimum"
  evaluation_periods = "2"
  period = "60"
  namespace = "AWS/ELB"
  actions_enabled = "true"
  alarm_actions = ["${aws_sns_topic.alarm.arn}"]
  ok_actions = [ ]
  insufficient_data_actions = ["${aws_sns_topic.alarm.arn}"]
  dimensions = {
    //    InstanceId = aws_instance.web.id
    "LoadBalancerName"="example"
//    InstanceId = "${var.instance_id}"
  }
}
resource "aws_cloudwatch_metric_alarm" "test-metric-unhealthy-elb" {
  alarm_name = "test-metric-unhealthy-elb"
  alarm_description = "This alarm will be created but not attached to an ELB."
  metric_name = "UnHealthyHostCount"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold = "0"
  statistic = "Maximum"
  evaluation_periods = "2"
  period = "60"
  namespace = "AWS/ELB"
  actions_enabled = "true"
  alarm_actions = ["${aws_sns_topic.alarm.arn}"]
  ok_actions = [ ]
  insufficient_data_actions = ["${aws_sns_topic.alarm.arn}"]
  dimensions = {
    //    InstanceId = aws_instance.web.id
    "LoadBalancerName"="terraform-asg-example"
    //    InstanceId = "${var.instance_id}"
  }
}