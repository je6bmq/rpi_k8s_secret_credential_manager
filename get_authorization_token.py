# this is for armv7 environment due to we cannot use aws cli at such environment.
import os
import boto3 

# use ~/.aws/{config,credentials} . see also https://boto3.amazonaws.com/v1/documentation/api/latest/guide/quickstart.html
client = boto3.client('ecr')

registry_id = os.environ['ECR_REGISTRY_ID']

response = client.get_authorization_token(registryIds=[registry_id])

print(response['authorizationData'][0]['authorizationToken'])