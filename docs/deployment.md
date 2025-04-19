# Deployment

## Minikube (Development)

1. Start Minikube: `minikube start`.
2. Deploy PostgreSQL: `kubectl apply -f k8s/postgres/`.
3. Deploy services with ArgoCD ApplicationSet.

## EKS (Staging/Production)

1. Apply Terraform: `terraform apply -var-file=prod.tfvars`.
2. Configure ArgoCD to watch `*/k8s/`.
3. Monitor with CloudWatch.
