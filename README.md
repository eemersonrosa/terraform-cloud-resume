# Terraform Cloud Resume (proof of concept)

> **Status: proof of concept, not deployed.** The
> AWS resources were torn down and the old domain was released. My resume now
> lives at **[eemersonrosa.github.io](https://eemersonrosa.github.io/)**
> ([source](https://github.com/eemersonrosa/eemersonrosa.github.io)).

My take on the [Cloud Resume Challenge](https://cloudresumechallenge.dev/): a
static resume site whose whole hosting stack is described in Terraform.

## What it builds

```
visitor ──HTTPS──▶ Cloudflare (proxy, always-HTTPS page rule)
                      │
        www.<domain> ─┴─▶ S3 website bucket  www.<domain>   (site files)
            <domain> ───▶ S3 website bucket  <domain>       (redirects to www)
```

| Path | What it does |
| --- | --- |
| `main.tf` | Providers, S3 remote state, the modules below, and uploads `cloud-resume/website/` to the bucket. |
| `modules/s3_bucket_sub` | `www.` bucket with static website hosting. A bucket policy allows reads **only from Cloudflare's IP ranges**, so the site cannot be reached around Cloudflare. |
| `modules/s3_bucket_apex` | Apex bucket that redirects every request to `www.`. |
| `modules/cloudflare` | Proxied CNAMEs for apex and `www`, plus an always-HTTPS page rule. |
| `modules/resource_group` | AWS Resource Group that collects everything carrying the common tags. |
| `vars.tf` | Inputs, with validation on the tag map (owner, email, env, region). |
| `.github/workflows/front-end-CICD.yml` | Manual `plan` / `apply` / `destroy` from the Actions tab. |
| `cloud-resume/website/` | The original resume page (Bootstrap + Typed.js). |

## Running it

Requirements: Terraform ≥ 1.5, an AWS account, a Cloudflare zone for your
domain, and an S3 bucket for state (change `backend "s3"` in `main.tf` to
yours).

```bash
cp terraform.tfvars.example terraform.tfvars   # set site_domain and tags
export TF_VAR_CLOUDFLARE_API_TOKEN=...          # Zone:DNS edit + Page Rules
terraform init
terraform plan
```

From GitHub Actions instead: add secrets `AWS_ACCESS_KEY_ID`,
`AWS_SECRET_ACCESS_KEY` and `CLOUDFLARE_API_TOKEN`, and repository variables
`SITE_DOMAIN` and `COMMON_TAGS` (HCL map, e.g.
`{owner="Jane Doe", created-by="jane@example.com", env="dmo", region="us-east-1"}`).
Then run the workflow by hand.

## Known limits (left as is for a POC)

- The Cloudflare IP list in the bucket policy is copied by hand. It goes stale
  if Cloudflare adds ranges; `cloudflare_ip_ranges` could feed it instead.
- Cloudflare talks to the S3 website endpoint over HTTP (S3 website endpoints
  have no HTTPS). Visitors still get HTTPS from Cloudflare.
- No `error.html` is uploaded, so missing pages show S3's default error.
- The visitor counter (API Gateway + Lambda + DynamoDB) from the challenge was
  never built.
