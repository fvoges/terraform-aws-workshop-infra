#!/bin/bash

exec > >(tee -i /var/log/tf_provisioning.log)
exec 2>&1

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" vim-nox bash-completion ccze colordiff curl git htop lftp lynx mc mutt psmisc rsync sysstat telnet wget tree ack-grep make jq && \
curl -q https://gist.githubusercontent.com/fvoges/741de3b432e19c11c9bb/raw/874ea086b0f5e4bc07945dad3ea840f85a248a9a/rcinstall.sh|bash
curl -q https://gist.githubusercontent.com/fvoges/741de3b432e19c11c9bb/raw/874ea086b0f5e4bc07945dad3ea840f85a248a9a/rcinstall.sh|su ubuntu -l -c bash
