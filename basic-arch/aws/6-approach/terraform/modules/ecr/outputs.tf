output "ecr_repository_url" {
  description = "URL of the ECR created."
  value = aws_ecr_repository.repo.repository_url
}