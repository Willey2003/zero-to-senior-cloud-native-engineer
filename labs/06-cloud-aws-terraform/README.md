# Lab 06: Cloud (AWS), Terraform and CI/CD

## Why this matters
Companies rent servers, networks and databases from cloud providers instead of buying hardware.
Terraform describes that infrastructure as code, so it is repeatable, reviewable and version-controlled.
CI/CD pipelines test and ship code automatically.

## SAFETY FIRST (do this before anything else)
1. Create an AWS account, enable **MFA on the root user**, then never use root again.
2. Create an IAM user/Identity Center user for yourself with MFA.
3. Create a **billing alarm / budget of $5** in AWS Budgets.
4. Always run `terraform destroy` at the end of a lab session.

## Module 1: Core AWS (by clicking first, then CLI)
| Concept | AWS service | Plain meaning |
|---|---|---|
| Identity | IAM | Who can do what |
| Network | VPC, subnets, route tables, IGW, NAT GW, security groups, NACLs | Your private data centre network |
| Compute | EC2, Auto Scaling, Lambda | Servers, auto-grow, run code without servers |
| Storage | S3, EBS, EFS | Object store, disks, shared files |
| Database | RDS, DynamoDB | Managed SQL, NoSQL |
| Traffic | ELB (ALB/NLB), Route 53, CloudFront | Load balancer, DNS, CDN |
| Watch | CloudWatch, CloudTrail | Metrics/logs, audit of every API call |
| Containers | ECR, ECS, EKS | Registry, container service, managed Kubernetes |

Hands-on: build by hand a VPC with 2 public + 2 private subnets, an EC2 web server in public, reach it,
then move it to private behind an ALB. Then delete everything and do it with Terraform below.

## Module 2: Terraform
```bash
cd terraform
terraform init          # download providers
terraform fmt && terraform validate
terraform plan          # READ this every time: what will change?
terraform apply
terraform output
terraform destroy
```
The code in `terraform/` builds: a VPC module (2 AZs, public/private subnets, NAT optional), a security group,
and an EC2 instance with user-data that installs nginx. Study `modules/vpc/main.tf` line by line.
Then add: remote state in S3 with locking, a `dev` and `prod` workspace, and an ALB.

## Module 3: CI/CD with GitHub Actions
`github-actions/ci.yaml` → copy to `.github/workflows/ci.yaml` in your repo. It:
lints and tests Python → builds the Docker image → scans it with Trivy → pushes to GHCR on `main`.
Then add a Terraform workflow that runs `plan` on pull requests and `apply` on merge (with OIDC to AWS, no stored keys).

## Real-world scenarios
1. **"EC2 in private subnet cannot download packages."** Missing NAT gateway or route. Fix the route table.
2. **"Website times out."** Security group allows 80 from the wrong CIDR, or NACL blocks return ephemeral ports.
3. **"Someone changed infra by hand."** `terraform plan` shows drift. Decide: import or revert.
4. **"Surprise $200 bill."** A NAT gateway / EKS cluster was left running. Find it in Cost Explorer; this is why budgets matter.

## Check yourself
- [ ] Draw a VPC with public/private subnets across 2 AZs and explain every arrow.
- [ ] Explain security group (stateful) vs NACL (stateless).
- [ ] Explain Terraform state and why it must be remote and locked in a team.

**Cert mapping:** AWS Solutions Architect Associate, HashiCorp Terraform Associate.
Azure equivalents: VNet, NSG, VM, Blob, Entra ID, AKS. GCP: VPC, Firewall rules, GCE, GCS, IAM, GKE.
