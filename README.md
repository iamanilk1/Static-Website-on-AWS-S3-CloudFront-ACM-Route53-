# Scenario 3 — Static Website on AWS (S3 + CloudFront + ACM + Route53)

This scenario provides a reusable, service-wise Terraform module setup and an example `dev` environment that deploys a secure, scalable static website (primary region defaults to ap-south-1):

- S3 bucket for website content (private)
- CloudFront distribution with Origin Access Control (OAC) to read from S3
- ACM certificate (in us-east-1) for your custom domain
- Route53 alias records pointing your domain to CloudFront
- Optional S3 object uploader to sync local static files

## Structure

- `modules/services/`
  - `s3/` — Private S3 bucket for static site (policy can restrict access to CloudFront)
  - `cloudfront/` — CloudFront distribution with OAC and HTTPS
  - `acm/` — DNS-validated ACM certificate (requires Route53 hosted zone)
  - `route53/` — Alias A records (apex and optional www) to CloudFront
  - `s3_objects/` — Optional uploader for local static files using `aws_s3_object`
- `environments/dev/` — Example environment wiring the modules

## Quick start

1) Ensure you have a Route53 public hosted zone for your domain; copy its `hosted_zone_id`.

2) Edit `environments/dev/terraform.tfvars.example` and save as `terraform.tfvars`.

3) (Optional) If you want remote state, edit `backend.tf` with your state bucket/table. Otherwise delete or comment it out.

4) Initialize and apply from the `environments/dev` folder.

```cmd
cd environments\dev
terraform init
terraform plan
terraform apply -auto-approve
```

When finished, outputs will show your CloudFront domain and the website URL.

Notes:
- Primary region for regional services (S3, Route53 interactions, state backend) defaults to `ap-south-1`.
- ACM and CloudFront must be created in `us-east-1`. The dev environment config already provides the alias provider for that.
- The S3 bucket is private and only readable via CloudFront (OAC). Accessing the bucket URL directly will be blocked.
- If `upload_enabled = true`, the module will upload all files from `site_dir` to S3 using `aws_s3_object`.
