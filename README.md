# pressr-wordpress
---
This repository contains files needed to build and deploy the PressR wordpress app.

## Deployment
The following environment variables need to be set:

|Environment Variable|Description|
|-------------------|-----------|
|`AWS_SECRET_ACCESS_KEY`|AWS Secret Access Key|
|`AWS_ACCESS_KEY_ID`|AWS Access Key ID|
|`TF_VAR_db_password`|Password used for the created AWS RDS Instance|
|`TF_VAR_sshpubkey_file`|Path to SSH private key (will be used to SSH in to EC2 Instances)|

Running the script:
```shell
$ ./deploy_app.sh

The following environment variables need to be set:
        AWS_SECRET_ACCESS_KEY
        AWS_ACCESS_KEY_ID
        TF_VAR_db_password
        TF_VAR_sshpubkey_file

Valid environments:
        development
        production

Usage: deploy_app.sh <environment> <tag>
```
Example:
```
$ ./deploy_app.sh development v1.0
```

The script will create a tag of the repository and push to origin, then clone the [pressr-orchestration](https://github.com/yasn77/pressr-orchestration) reporistory and run the `pressr_deploy.yml` playbook.
