#!/bin/sh -e

# all parameters are must be specified.
aws_access_key_id=${AWS_ACCESS_KEY_ID:?"you must specify AWS IAM access key id"}
aws_secret_access_key=${AWS_SECRET_ACCESS_KEY:?"you must specify AWS IAM secret access key"}
region=${AWS_ECR_REGION:?"you must specify ECR region name"}
registry_id=${ECR_REGISTRY_ID:?"you must specify registry id (account id)"}

secret_name=${K8S_SECRET_NAME_ECR_CREDENTIAL:?"you must specify k8s secret name to manage ecr credential."}
ecr_url="${registry_id}.dkr.ecr.${region}.amazonaws.com"

mkdir -p ~/.aws/
# Access key [a-zA-Z0-9]
# Secret Access key [a-zA-Z0-9/+]
sed -e "s/{{ region }}/${region}/g" aws_config_template > ~/.aws/config
sed -e "s@{{ aws_secret_key_id }}@${aws_secret_key_id}@g" aws_credentials_template > ~/.aws/credentials
sed -i -e "s@{{ aws_secret_access_key }}@${aws_secret_access_key}@g" ~/.aws/credentials

authorization_token=$(python3 ./get_authorization_token.py) # use ~/.aws/config, ~/.aws/credentials internally
userpass=$(echo -n ${authorization_token} | base64 -d)
username="AWS"
password=$(echo -n ${userpass} | sed "s/^${username}://g") # userpass forms username:password and username equals to AWS.


# delete/create for update
set -x
kubectl delete secret ${secret_name} --ignore-not-found=true # ignore not found for first creation
kubectl create secret docker-registry ${secret_name} --docker-server=${ecr_url} --docker-username=${username} --docker-password=${password}
set +x