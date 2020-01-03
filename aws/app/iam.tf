# IAM role for task and executable role
resource "aws_iam_role" "ecs_role" {
  name_prefix = "hubot-ecs-role-"
  path        = "/hubot/"
  description = "The task role for the Hubot service"
  tags        = local.tags

  assume_role_policy = jsonencode({
    Version = "2008-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = [
            "ecs.amazonaws.com",
            "ecs-tasks.amazonaws.com"
          ]
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# resource "aws_iam_role_policy_attachment" "ecs_secrets" {
#   role       = aws_iam_role.ecs_role.name
#   policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
# }

resource "aws_iam_role_policy" "ecs_secrets" {
  name = "ReadOnlyTokens"
  role = aws_iam_role.ecs_role.id

  policy = jsonencode({
    Statement = [
      {
        Sid      = "ReadSlackToken",
        Effect   = "Allow"
        Resource = aws_secretsmanager_secret.default.arn,
        Action   = ["secretsmanager:GetSecretValue"],
      }
    ]
    }
  )
}


resource "aws_iam_role" "ecs_exec_role" {
  name_prefix = "hubot-role-"
  path        = "/hubot/"
  description = "The execution task role for the Hubot service"
  tags        = local.tags

  assume_role_policy = jsonencode({
    Version = "2008-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = [
            "ecs-tasks.amazonaws.com"
          ]
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecs_exec_ecr" {
  name = "AmazonECSTaskExecutionRolePolicy"
  role = aws_iam_role.ecs_exec_role.id

  policy = jsonencode({
    Statement = [
      {
        Sid      = "ReadECR",
        Effect   = "Allow"
        Resource = "*",
        Action = [
          "ecr:GetAuthorizationToken",
        ],
      },
      {
        Sid      = "ReadHubotImage",
        Effect   = "Allow"
        Resource = data.aws_ecr_repository.default.arn,
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
        ],
      },
      {
        Sid    = "ReadWriteCloudwatchLogs",
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Resource = aws_cloudwatch_log_group.logs.arn
      },
    ]
    }
  )
}
