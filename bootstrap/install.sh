#!/bin/bash
wget https://releases.hashicorp.com/terraform/1.7.1/terraform_1.7.1_linux_amd64.zip
unzip terraform_1.7.1_linux_amd64.zip
rm terraform_1.7.1_linux_amd64.zip
mv terraform /usr/local/bin/