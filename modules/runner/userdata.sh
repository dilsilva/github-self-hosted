#!/bin/bash

#Github Actions
sudo yum update -y && \
sudo yum install docker -y && \
sudo yum install git -y && \
sudo yum install libicu -y && \
sudo systemctl enable docker

# Create a folder
mkdir actions-runner && cd actions-runner
# Download the latest runner package
curl -o actions-runner-linux-x64-2.321.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.321.0/actions-runner-linux-x64-2.321.0.tar.gz
# Optional: Validate the hash
echo "ba46ba7ce3a4d7236b16fbe44419fb453bc08f866b24f04d549ec89f1722a29e  actions-runner-linux-x64-2.321.0.tar.gz" | shasum -a 256 -c
# Extract the installer
tar xzf ./actions-runner-linux-x64-2.321.0.tar.gz
# Create the runner and start the configuration experience
./config.sh --unattended --url https://github.com/dilsilva/surepay --token ADMDQVGIQVD3IP7QSANPRQLHJUHQE
# Last step, run it!
./run.sh&

# Setup as system service
./svc.sh