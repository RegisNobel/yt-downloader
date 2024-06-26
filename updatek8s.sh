#!/bin/bash
set -ex

# Set the repository URL
REPO_URL="https://github.com/${GITHUB_REPOSITORY}"

# Check if the run number argument is provided
if [ -z "$1" ]; then
  echo "Error: Run number is required as the first argument."
  exit 1
fi

RUN_NUMBER=$1
echo "Run number: $RUN_NUMBER"

# Cleanup: remove the temporary directory
rm -rf /tmp/temp_repo

# Clone the git repository into the /tmp directory
git clone "$REPO_URL" /tmp/temp_repo

# Navigate into the cloned repository directory
cd /tmp/temp_repo

# Configure Git with your name and email
git config --global user.email "regisnobel95@gmail.com"
git config --global user.name "RegisNobel"

# Make changes to the Kubernetes manifest file(s)
# For example, let's say you want to change the image tag in a deployment.yaml file
sed -i "s|image:.*|image: ytdlregistry.azurecr.io/ytdlimages:$RUN_NUMBER|g" manifests/deployment.yaml
echo "Updated deployment.yaml with new image tag"

# Add the modified files
git add .

# Commit the changes
git commit -m "Manifest update by pipeline [skip ci]"

# Push the changes back to the repository
git push "https://${GITHUB_ACTOR}:${GH_TOKEN}@github.com/${GITHUB_REPOSITORY}.git" HEAD:main

# Cleanup: remove the temporary directory
rm -rf /tmp/temp_repo
