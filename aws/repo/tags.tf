data "aws_region" "current" {}

locals {
  tags = {
    Name          = "Hubot"
    Description   = "Stores the slack tokens for Hubot."
    Project       = "hubot-in-aws"
    RepositoryURL = "github.com:jrbeverly/hubot-in-aws"
  }
}
