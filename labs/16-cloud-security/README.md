# Lab 16: Cloud Security (AWS focus, concepts apply to Azure/GCP)

## Mental model
Cloud security = **identity is the new perimeter**. Most real breaches: leaked access keys, over-permissive IAM,
public S3 buckets, exposed metadata service (SSRF → IMDS), unpatched internet-facing services, no logging.
Shared responsibility: AWS secures the cloud, **you** secure what you put in it.

## Modules
1. **Identity**: IAM users vs roles, least privilege (`policies/least-privilege-s3.json`), permission boundaries,
   SCPs in AWS Organizations (`policies/scp-deny-regions.json`), IAM Access Analyzer, no long-lived keys (use SSO + OIDC for CI).
2. **Data protection**: KMS keys and key policies, S3 Block Public Access, bucket policies, encryption at rest/in transit, Secrets Manager rotation.
3. **Network**: private subnets, security groups, VPC endpoints (no internet for S3 traffic), WAF, Shield, VPC Flow Logs.
4. **Detection**: CloudTrail (org trail), GuardDuty, Security Hub, AWS Config rules, Inspector, Macie, Detective.
5. **Kubernetes on cloud (EKS)**: IRSA / EKS Pod Identity, private API endpoint, envelope encryption of Secrets, GuardDuty EKS protection.
6. **Posture and policy as code**: `prowler aws` (CSPM), `checkov -d terraform/`, `tfsec`/`trivy config`, OPA/Conftest in CI.
7. **Incident response**: runbook in `ir-runbook.md` for a leaked access key.

## Hands-on
```bash
pip install prowler checkov
prowler aws --compliance cis_2.0_aws                 # read the findings, fix 10
checkov -d ../06-cloud-aws-terraform/terraform       # find misconfigurations in YOUR Terraform
aws iam simulate-principal-policy --policy-source-arn <role-arn> --action-names s3:GetObject --resource-arns arn:aws:s3:::bucket/*
```

## Real-world scenarios
1. **Leaked key on GitHub** (follow `ir-runbook.md`): deactivate, investigate CloudTrail, rotate, clean up, enable secret scanning.
2. **SSRF to IMDS**: why IMDSv2 (`http_tokens = "required"` in Lab 06 Terraform) blocks it.
3. **Public S3 bucket with customer data**: find with Macie/Prowler, block, check access logs for exfiltration.
4. **Crypto-mining EC2 instances in an unused region**: GuardDuty finding → SCP to deny unused regions.

**Cert mapping:** AWS Security Specialty; complements CKS/KCSA. Azure: AZ-500, SC-100. Vendor-neutral: CCSK.
