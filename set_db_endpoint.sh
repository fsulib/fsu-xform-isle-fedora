#!/usr/bin/env bash

echo $CODEBUILD_WEBHOOK_HEAD_REF | grep -q 'local' && export DB_ENDPOINT=$DB_ENDPOINT_LOCAL
echo $CODEBUILD_WEBHOOK_HEAD_REF | grep -q 'test' && export DB_ENDPOINT=$DB_ENDPOINT_TEST
echo $CODEBUILD_WEBHOOK_HEAD_REF | grep -q 'prod' && export DB_ENDPOINT=$DB_ENDPOINT_PROD
echo $CODEBUILD_WEBHOOK_HEAD_REF | grep -q 'local' && export IMAGE_TAG=local
echo $CODEBUILD_WEBHOOK_HEAD_REF | grep -q 'test' && export IMAGE_TAG=test
echo $CODEBUILD_WEBHOOK_HEAD_REF | grep -q 'prod' && export IMAGE_TAG=prod
test -z $CODEBUILD_WEBHOOK_HEAD_REF && export DB_ENDPOINT=$DB_ENDPOINT_TEST
test -z $CODEBUILD_WEBHOOK_HEAD_REF && export IMAGE_TAG=test

exit 0
