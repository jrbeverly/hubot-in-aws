resource "aws_ecr_repository" "default" {
  name                 = var.name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = local.tags
}

output "repository_url" {
  description = "The URL of the repository. Used by the build-harness to tag the docker image."
  value       = aws_ecr_repository.default.repository_url
}

variable "name" {
  type        = string
  description = "Name of the repository."
  default     = "hubot"
}
