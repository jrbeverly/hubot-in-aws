# Reference the image repository for the hubot application
data "aws_ecr_repository" "default" {
  name = "hubot"
}

locals {
  ecr_repository_version = "latest"
  ecr_repository_image   = "${data.aws_ecr_repository.default.repository_url}:${local.ecr_repository_version}"
}
