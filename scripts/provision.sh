#!/bin/bash

set +x
# exit on error
set -e
# error on undefined variables
set -u
# fail on pipe errors
set -o pipefail

export DEBIAN_FRONTEND=noninteractive

echo "Setting up the MOTD"
cat >/etc/update-motd.d/99-neofetch <<EOF
!#/sh

neofetch
EOF
chmod +x /etc/update-motd.d/99-neofetch

echo "Installing AWS CLI v2"
curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "/tmp/awscliv2.zip"
unzip -qq /tmp/awscliv2.zip -d /tmp
/tmp/aws/install

echo "Installing dotfiles"
curl -q https://gist.githubusercontent.com/fvoges/741de3b432e19c11c9bb/raw/rcinstall.sh|bash
curl -q https://gist.githubusercontent.com/fvoges/741de3b432e19c11c9bb/raw/rcinstall.sh|su ubuntu -l -c bash

# get the list of users passed to the script and for each run the provision.sh script
for user in "$@"; do
  echo "Running provision for user: $user"
  curl -q https://gist.githubusercontent.com/fvoges/741de3b432e19c11c9bb/raw/rcinstall.sh|su $user -l -c bash
  su $user -l -c bash 'git clone --depth=1 https://github.com/fvoges/hands-on-automation-lab'
done

# certbot --nginx -d lab-bastion.aws.voges.uk --non-interactive --agree-tos -m fvoges@gmail.com
