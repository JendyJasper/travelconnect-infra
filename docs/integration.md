# Infra Integration

- EKS: Hosts all services and API Gateway.
- Cognito: Authenticates users for User Service.
- RDS: Stores data for all services.
- S3/CloudFront: Serves images for Meetup Service.
- API Gateway: Routes REST requests in production.

## Dependencies

- All service repos: Deployed on EKS.
