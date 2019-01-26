# Terraform demo
First thing you need to do is to fill your terraform.tfvars. Specifically, you need to provide:
 * aws_access_key
 * aws_secret_key
 * localhost_public_key
 
After that, we will walkthrough this tutorial together. We will be copying files from demo-files to the root
directory `devconf` and we will interact with `terraform` tool.

## Create RDS 

Notice *.tf, *.tfvars - everything in the directory is loaded by TF

To apply the changes use
```
terraform apply 
```

The variables are interpolated and resources resolved in the correct order.

Arguments vs Attributes
     https://www.terraform.io/docs/providers/aws/r/db_instance.html  
     
Resource vs Data
    https://www.terraform.io/docs/providers/aws/d/db_instance.html
    https://www.terraform.io/docs/providers/aws/r/db_instance.html
   
Provider, VPC - advanced resource 
  https://www.terraform.io/docs/providers
  https://www.terraform.io/docs/providers/aws/r/default_vpc.html

Terraform State

Look into the terraform.tfstate and locate address key of attributes hash.
```
   aws_db_instance.luncherdb
```
   
## Create S3

```
terraform -target 
```

The dependency graph!

https://www.terraform.io/docs/providers/aws/r/iam_access_key.html

```
terraform output
```

## EC2 instance
aws_default_security_group advanced resource 
aws_key_pair.default.key_name
provisioners

To connect to the EC2 instance

```
SERVER=$(terraform output luncherapi)
ssh ubuntu@$SERVER
```

```
RDS_HOST=${aws_db_instance.luncherdb.address} RDS_USER=test RDS_PASS=testpass RDS_DB=luncherdb nohup java -jar luncherapi.jar &
```

To hit the API
```
curl -X GET $SERVER:8080/places | jq '.'
curl -X POST  -H "auth:filip"  $SERVER:8080/vote/Kometa | jq '.'
```

To taint
```
terraform taint aws_instance.luncherapi
```

## Lambda 
```
curl -X GET $SERVER:8080/clusters | jq '.'
```

## Notes
To generate dependency graph of your infrastructure
```
terraform graph | dot -Tsvg > graph.svg
```

To destroy whole infrastructure
```
terraform destroy
```
