#!/usr/bin/env bash
. .bash_include

error=0
if test -z "$AWS_PROFILE";then echo "please set AWS_PROFILE";error=1;fi
if test -z "$AWS_REGION";then echo "please set AWS_REGION";error=1;fi
if test -z "$STACK_NAME";then echo "please set STACK_NAME";error=1;fi
if test -z "$KMS_KEY_NAME";then echo "please set KMS_KEY_NAME";error=1;fi
if test -z "$S3_BUCKET_CF_ARTIFACT";then echo "please set S3_BUCKET_CF_ARTIFACT";error=1;fi

if test $error -ne 0;then exit;fi

while true;do

options=()
options+=("aws cloudformation package --template-file template/template.yml --s3-bucket $S3_BUCKET_CF_ARTIFACT --output-template-file template/template-generated.yml")
options+=("aws cloudformation deploy --template-file template/template-generated.yml --stack-name $STACK_NAME --parameter-overrides KeyName=$KMS_KEY_NAME --capabilities CAPABILITY_IAM")
options+=("aws elasticbeanstalk describe-environments --query 'Environments[*].CNAME' --output text")
options+=("aws cloudformation describe-stack-events --stack-name $STACK_NAME --output text")
options+=("break")

select_option "${options[@]}"
choice=$?
opt=${options[$choice]}

echo "$(date) executing choice:$choice , $opt"
$opt

sleep .1
echo " 
"
done
