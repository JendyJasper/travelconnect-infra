# Deployment

## Minikube (Development)

1. Start Minikube: `minikube start`.
2. Deploy PostgreSQL: `kubectl apply -f k8s/postgres/`.
3. Deploy services with ArgoCD ApplicationSet.

## EKS (Staging/Production)

1. Apply Terraform: `terraform apply -var-file=prod.tfvars`.
2. Configure ArgoCD to watch `*/k8s/`.
3. Monitor with CloudWatch.

---

Infrastructure Deployment
 ## Step 1 Progress
 - **Cognito**: Completed with Hosted UI (Google/Facebook logins). Commits: infra (`14ab14e`, `420b6a6`), user-service (`5b054eb`).
 - **PostgreSQL**:
   - Deployed in Minikube (`travelconnect` namespace) using `k8s/postgres/` manifests (`420b6a6`).
   - Database `travelconnect` created with tables: `users`, `meetups`, `payments` (`db/schema.sql`).
   - Uses `Deployment` for simplicity; `StatefulSet` planned for EKS.
   - `emptyDir` for ephemeral storage; PVCs/RDS for production.
   - Port forwarding (`kubectl port-forward svc/postgres 5432:5432 -n travelconnect &`) for local testing, stopped with `pkill -f "kubectl port-forward"`.
 - **gRPC Protos**: Defined `user.proto`, `meetup.proto`, `payment.proto`, etc. in `travelconnect-protos` (`06ee835`).
 - **Next**: User Service implementation, 9Pay integration (post-approval), Step 2 (User/Meetup Services).

