Day01: What is Terraform and first apply
Terraform is an Infrastructure as Code (IaC) means we can describe infrastructure in text files, keep them in Git a tool can create in reality and match it with the files. It is repeatable, reviewable and versioned.
The core workflow is code.tf -> terraform init -> terraform plan -> terraform apply -> terraform destroy
init download the providers (plugins that can talk to various cloud platforms)
plan: it shows what will change
apply: makes the changes as per the .tf file and records in statefile
destroy: removes everything that terraform manges in the folder
Terraform only reads the .tf files in the directory you run it from. It doesn’t look in subfolders. That directory is called the root module, and every folder is its own separate Terraform project with its own state.
If we apply twice, Terraform refresh the state against the real infrastructure, then compares it with the configuration. Since everything is matched the plan will be empty. 
Attributes can not be updated in place, so the provider marks in force replacement.
Deleted statefile? Terraform looses its memory and plans to create everthing. the fix is terraform import.
The version constraint says what’s allowed; the lock file says what’s actually used. That way, my laptop, my teammates and Jenkins all run identical provider versions, and upgrades are deliberate, reviewed changes.
Day02: AWS provider and first S3 bucket creation.
Provider: a plugin that traslates HCL to API calls. 
provider block: how to connect, which region, which credentials
default_tags: tags automatically added to every resource.
Modern AWS provider style: bucket settings such as versioning and public-access blocking are separate resources, not arguments inside aws_s3_bucket.
if terraform fmt print something, it means it found formatting issues and fixed the file in place. If the file is already been clean, it shows nothing
fmt changes only layout, not behaviour
terraform fmt -diff show what it changed
terraform fmt -check changes nothing and exits with error
terraform fmt -recursive formats subfolders too
terraform validate checks syntax and internal consistency (references, types, required arguments). It does not check things like whether a bucket name is already taken in AWS; only plan/apply discover that.
Terraform applies aren’t transactional. If an apply fails halfway, resources created before the failure stay in state, and there’s no automatic rollback. You fix the cause and re-run plan and apply, and Terraform continues from the current state.
Terraform builds a dependency graph from references. Dependent resources are created in order and runs independent once in parallel.
Interview version: “S3 bucket names are globally unique across all AWS accounts, so I add a random suffix with random_pet. The value is saved in state, so it stays the same across runs and doesn’t trigger a replacement. In real projects we usually use a naming convention instead, such as company-env-purpose plus the account ID
It depends on whether the underlying API can modify that property. Tags can be changed on an existing bucket, so Terraform updates in place. Some attributes can’t be changed after creation, such as a bucket name or an EC2’s AMI, so the provider marks them as forcing replacement, and the plan shows -/+. That’s why I always check for forces replacement before applying
Renaming an S3 bucket in Terraform forces replacement. Terraform doesn’t copy data, so for a real bucket I’d create the new bucket, sync the data, update consumers, and only then remove the old one. In production I’d also add lifecycle { prevent_destroy = true } so an accidental replace fails safely
