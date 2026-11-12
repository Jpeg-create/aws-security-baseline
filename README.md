# aws-security-baseline

Terraform baseline for a single AWS account: cost guardrails, audit logging, threat detection.
Later phases add AWS Config, Security Hub, and auto-remediation Lambdas.

## Phase 1 (this commit)

| Control | Resource |
|---|---|
| Cost alerts | AWS Budgets, absolute USD thresholds plus forecast alert |
| Audit log | Multi-region CloudTrail, log validation, private encrypted S3, 30 day expiry |
| Threat detection | GuardDuty detector |
| State | S3 remote state with native locking (Terraform 1.10+) |

## Manual steps first (console, 15 minutes)

1. Enable MFA on the root user.
2. Create an admin user in IAM Identity Center, sign in through the SSO portal.
3. Never use root again.
4. `aws configure sso`, then `export AWS_PROFILE=<your-profile>`.

## Deploy

```bash
# 1. state bucket (local state, run once)
cd bootstrap
terraform init
terraform apply -var="state_bucket_name=<globally-unique-name>"

# 2. baseline
cd ../baseline
# edit versions.tf: set the backend bucket to the value from step 1
cp terraform.tfvars.example terraform.tfvars   # set alert_email
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

Confirm the budget subscription email AWS sends you.

## Teardown (Dec 5)

```bash
cd baseline && terraform destroy
cd ../bootstrap && terraform destroy   # empty the bucket first, versions included
```

## Roadmap

- [ ] AWS Config with managed rules (s3 public access, restricted SSH, EBS encryption)
- [ ] Security Hub, AWS foundational standard
- [ ] EventBridge to Lambda auto-remediation (public bucket, open SG)
- [ ] Violation test log: create the issue, show the detection, show the fix
- [ ] Checkov in GitHub Actions
- [ ] Architecture diagram and findings report
