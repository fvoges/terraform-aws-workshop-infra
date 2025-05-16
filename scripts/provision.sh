#!/bin/bash

set -e
set -x
set -o pipefail

export DEBIAN_FRONTEND=noninteractive

cat >/etc/update-motd.d/99-neofetch <<EOF
!#/sh

neofetch
EOF
chmod +x /etc/update-motd.d/99-neofetch

curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "/tmp/awscliv2.zip"
unzip /tmp/awscliv2.zip  -d /tmp
/tmp/aws/install

curl -q https://gist.githubusercontent.com/fvoges/741de3b432e19c11c9bb/raw/rcinstall.sh|bash
curl -q https://gist.githubusercontent.com/fvoges/741de3b432e19c11c9bb/raw/rcinstall.sh|su ubuntu -l -c bash

get the list of users passed to the script and for each run the provision.sh script
for user in "$@"; do
  echo "Running provision for user: $user"
done


