# AWS ECR imagePullSecret Manager (Updater) for Raspberry Pi Cluster
When you create imagepull secret by 

```
kubectl create secret docker-registry <secret name>  --docker-server <your ECR URL> --docker-username=AWS --docker-password=$(aws ecr get-login-password)
```
, it will be expired about 12 hours later.

The image which built from Dockerfile in this repo can update k8s secret which indicates ECR credential.

methodology:
1. get latest login-password by AWS SDK
1. update (delete/create) secret by kubectl inside container

# build 

```
docker build -t <image name> . 
```

# usage
you must specify following environment variable at runtime in Pod, Job, ...

|variable name|description|
|:---|:---|
|`AWS_ACCESS_KEY_ID`|AWS IAM account's access key id (to get authorization token for ECR)|
|`AWS_SECRET_ACCESS_KEY`|AWS IAM account's secret access key (to get authorization token for ECR)|
|`AWS_ECR_REGION`|ECR region name|
|`K8S_SECRET_NAME_ECR_CREDENTIAL`|k8s secret name which used imagePullSecrets|
|`ECR_REGISTRY_ID`|ECR's registry id. it is a AWS account ID which are associated with the registry.|
