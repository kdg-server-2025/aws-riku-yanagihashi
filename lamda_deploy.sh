#!/bin/bash
set -exo pipefail

# Configuration
TEMPDIR=$(mktemp -d)
ARTIFACT_BUCKET="kdg-aws-2025-riku-yanagihashi-lambda-artifacts"
FUNCTION_NAME="first-function"

# Build and package
echo "Building Lambda function..."
cp function/* "$TEMPDIR"
cd "$TEMPDIR"
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o bootstrap main.go
zip deployment-package.zip bootstrap
cd -

# Upload to S3
echo "Uploading to S3..."
aws s3 cp "$TEMPDIR/deployment-package.zip" "s3://$ARTIFACT_BUCKET/"

# Update Lambda function
echo "Updating Lambda function..."
aws lambda update-function-code \
  --no-cli-pager \
  --function-name "$FUNCTION_NAME" \
  --s3-bucket "$ARTIFACT_BUCKET" \
  --s3-key deployment-package.zip \
  --publish

rm -rf "$TEMPDIR"
set +x
echo "INFO: デプロイ成功"
