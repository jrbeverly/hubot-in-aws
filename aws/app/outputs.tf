output "secret_id" {
  description = "The name of the secret containing the slack secrets."
  value       = aws_secretsmanager_secret.default.name
}
