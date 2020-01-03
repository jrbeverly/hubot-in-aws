# Available logs for the ECS service
locals {
  time_month = 30
  logs_prefix = "hubot-"
}

resource "aws_cloudwatch_log_group" "logs" {
  name_prefix       = "ecs-hubot-in-aws-logs-"
  retention_in_days = 3 * local.time_month
  tags              = local.tags
}
