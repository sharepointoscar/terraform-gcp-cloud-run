# Getting Started


## Use Docker GCP Docker image.

1. download image docker pull gcr.io/google.com/cloudsdktool/cloud-sdk:latest  
2. Execute and authenticate 

```bash
 docker run -ti --name gcloud-config gcr.io/google.com/cloudsdktool/cloud-sdk gcloud auth login
```
 Once you've authenticated successfully, credentials are preserved in the volume of the gcloud-config container.

 More Info: https://cloud.google.com/sdk/docs/downloads-docker

### List Compute Instances CLI command
List compute instances using these credentials to verify by running the container with --volumes-from
```
docker run --rm --volumes-from gcloud-config gcr.io/google.com/cloudsdktool/cloud-sdk gcloud compute instances list --project public-apps-282115
```

### List Google Run Services

```
docker run --rm --volumes-from gcloud-config gcr.io/google.com/cloudsdktool/cloud-sdk gcloud run services list --platform managed
```



## Run Container Interactively with local volume mounted
The mounted volume will be in a spot similar to `/Users/osmed/git-repos/terraform-gcp-cloud-run` which is my current directory where I run the following command.

Run the container with the gcloud name and volume mapped.
```
docker container run -it --name gcloud  -v "$PWD:$PWD" --volumes-from gcloud-config gcr.io/google.com/cloudsdktool/cloud-sdk /bin/bash
```

NOTE: might need to authenticate to gcp again, run `gcloud auth application-default login` and paste the `token` for your session.

## Install and Run Terraform In Container

1. Install common components `apt-get install software-properties-common`
2. Update `apt-get update`
3. Add HashiCorp key `curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -`
4. Add HashiCorp Repository `apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"`
5. Update and install `apt-get update && apt-get install terraform`

## Initialize and Run Terraform

1. Switch to mounted directory.
2. Run `terraform init`
3. Run `terraform plan`


**REFERENCES:**

1. https://cloud.google.com/run/docs/deploying#terraform