#!/bin/bash

curl -q https://gist.githubusercontent.com/fvoges/741de3b432e19c11c9bb/raw/rcinstall.sh|bash

git config --global user.name "${USER}"
git config --global user.email "${USER}@${HOSTNAME}"

git clone https://github.com/fvoges/terraform-aws-basic-infra.git
git clone https://github.com/fvoges/hands-on-automation-lab.git

ssh-keygen -f ~/.ssh/id_d25519 -t ed25519 -N "" -C $USER@lab-bastion.aws.voges.uk
cat ~/.ssh/id_d25519.pub >> ~/.ssh/authorized_keys

