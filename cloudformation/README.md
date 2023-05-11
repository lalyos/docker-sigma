## Create Stack

From uploaded template:

```
aws cloudformation create-stack \
  --stack-name fasza \
  --template-url https://lalyoscs9.s3.eu-central-1.amazonaws.com/s3.yaml \
  --parameters ParameterKey=StaticBucketName,ParameterValue=xxxxxxxxmaslesz

```