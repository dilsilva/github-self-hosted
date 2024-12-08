#!/bin/bash -x
sudo apt-get update
sudo apt install jq git unzip ca-certificates curl -y

#Docker
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli -y
sudo groupadd docker
sudo usermod -aG docker ubuntu
sudo newgrp docker


# Golang
sudo wget https://go.dev/dl/go1.23.4.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.23.4.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin


# awscli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
sudo rm -rf awscliv2.zip

mkdir /home/ubuntu/actions-runner && cd /home/ubuntu/actions-runner

curl -s https://github.com/actions/runner/releases | grep -o -E "https://github.*actions-runner-linux-x64-[0-9\.]+.tar.gz" | sort | uniq > versions.txt
RUNNER_FILE_LINK=`cat versions.txt | tail -n1`
curl -o actions-runner-linux-x64.tar.gz -L $RUNNER_FILE_LINK
tar xzf ./actions-runner-linux-x64.tar.gz

# Configure actions-runner
PERSONAL_ACCESS_TOKEN=`aws ssm get-parameter --with-decryption --name ${ssm_parameter_name} --region ${aws_region} | jq -r '.Parameter.Value'`
TOKEN_RESPONSE=`curl -X POST -H "Accept: application/vnd.github+json" -H "Authorization: token $PERSONAL_ACCESS_TOKEN" https://api.github.com/repos/${github_owner}/${github_repo}/actions/runners/registration-token`
TOKEN=`echo $TOKEN_RESPONSE | jq -r '.token'`
RUNNER_ALLOW_RUNASROOT=true ./config.sh --url ${github_url} --unattended --token $TOKEN ${runner_group} ${runner_labels}

# Install as service
RUNNER_ALLOW_RUNASROOT=true  ./svc.sh install
echo ==== ACTIONS-RUNNER DONE ====

RUNNER_ALLOW_RUNASROOT=true ./run.sh