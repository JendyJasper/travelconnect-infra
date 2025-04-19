# Infra Architecture

- Tool: Terraform.
- Resources: EKS, Cognito, RDS, S3, API Gateway, etc.
- Modules: `terraform/eks/`, `terraform/cognito/`, etc.
- Deployment: Minikube (dev), EKS (prod) with ArgoCD.

## Flow

1. Terraform provisions EKS cluster.
2. ArgoCD deploys services from `*/k8s/`.
3. Services connect to RDS, Cognito, etc.
