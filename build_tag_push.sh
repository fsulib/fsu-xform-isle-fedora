#!/usr/bin/env bash

# Pushing to ECR. Would rather do this as individual commands.

IMAGE_TAG=$(echo $CODEBUILD_WEBHOOK_HEAD_REF | cut -d / -f 3)

[[ $IMAGE_TAG ]] || IMAGE_TAG=test

echo "IMAGE_TAG is $IMAGE_TAG"

echo "Building image..."
cd isle-fedora
docker build -t $IMAGE_REPO_NAME:$IMAGE_TAG .
echo "Tagging image..."
docker tag $IMAGE_REPO_NAME:$IMAGE_TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$IMAGE_TAG
echo "Pushing image..."
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$IMAGE_TAG
