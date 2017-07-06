# Kontena Google Cloud Platform Terraform

STATUS: https://github.com/hashicorp/terraform/pull/10907 is open (and abandoned?) and https://github.com/terraform-providers/terraform-provider-google/issues looks bad. going back to gcloud.

## setup

    $ brew install terraform

Download service credentials as account.json

### create main.tfvars

```
gcp_project = "yourproject"
gcp_region = "us-west1"

master_uri = "wss://yourmaster.herokuapp.com"
grid_token = "yourtoken"
docker_opts = ""
peer_interface = "ens4v1"
```

### Initiate remote state

    $ gsutil mb gs://YOURNAME
    $ bin/tf init -backend-config "bucket=YOURNAME" -backend-config "path=default"
    $ bin/tf get

## usage

    $ kontena grid create --initial-size 1 YOURGRID
    $ kontena grid show --token YOURGRID

    $ bin/tf apply
