#!/usr/bin/env bash
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_STS AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SECURITY_TOKEN AWS_SESSION_TOKEN
export USERNAME=sebastien.lavayssiere
export AWS_DEFAULT_REGION=eu-west-1
export AWS_ACCESS_KEY_ID=AKIAIRGUFPABC7RNLWZQ
export AWS_SECRET_ACCESS_KEY=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
export ROLE_NAME=iaas_builders-rds
export ACCOUNT_ARN=arn:aws:iam::543443504517
export MFA_CODE=$1
AWS_STS=($(aws sts assume-role --role-arn $ACCOUNT_ARN:role/$ROLE_NAME --serial-number $ACCOUNT_ARN:mfa/$USERNAME --query '[Credentials.AccessKeyId,Credentials.SecretAccessKey,Credentials.SessionToken,Credentials.Expiration]' --output text --token-code $MFA_CODE --role-session-name $ROLE_NAME))
export AWS_ACCESS_KEY_ID=${AWS_STS[0]}
export AWS_SECRET_ACCESS_KEY=${AWS_STS[1]}
export AWS_SECURITY_TOKEN=${AWS_STS[2]}
export AWS_SESSION_TOKEN=${AWS_STS[2]}

