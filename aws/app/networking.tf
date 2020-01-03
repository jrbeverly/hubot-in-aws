# Networking from scratch. Not optimal, just a fresh starter (ideally handled by module instead of manual)
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = local.tags
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = local.tags
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags   = local.tags
}

resource "aws_route" "main_route" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_security_group" "ecs_sg" {
  name        = "hubot_slack_internet"
  description = "Allows access to Slack from the container"
  vpc_id      = aws_vpc.main.id
  tags        = local.tags

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow access to Slack"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
}
