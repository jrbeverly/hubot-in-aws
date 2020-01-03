# Store the slack token in a secret store. Exposing by environment isn't ideal
resource "aws_secretsmanager_secret" "default" {
  name_prefix = "hubot-slack-token-"
  description = "Stores the slack tokens for Hubot."

  tags = {
    Name          = "Hubot"
    Description   = "Stores the slack tokens for Hubot."
    Project       = "hubot-in-aws"
    RepositoryURL = "github.com:jrbeverly/hubot-in-aws"
  }
}
