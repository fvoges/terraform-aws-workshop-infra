#cloud-config
apt:
  sources :
    hashicorp:
      source: deb [signed-by=$KEY_FILE] https://apt.releases.hashicorp.com $RELEASE main
      keyid: 798AEC654E5C15428C8E42EEAA16FCBCA621E701
    docker:
      source: deb [signed-by=$KEY_FILE] https://download.docker.com/linux/ubuntu $RELEASE stable
      keyid: 9DC858229FC7DD38854AE2D88D81803C0EBFCD88

# create the docker group
groups:
  - docker

# Add default auto created user to docker group
system_info:
  default_user:
    groups: [docker]

users:
  - default
  - name: root
    ssh_authorized_keys:
      - ${ ssh_key }
  - name: ubuntu
    gecos: Ubuntu
    primary_group: ubuntu
    groups: users, admin
    lock_passwd: false
    ssh_authorized_keys:
      - ${ ssh_key }
%{ for user in users ~}
  - name: ${ user.name }
    gecos: ${ user.gecos }
    principal_group: ${ user.name }
    groups: users
    shell: /bin/bash
    lock_passwd: false
    plain_text_passwd: ${ user.password }
    ssh_authorized_keys:
      - ${ user.ssh_authorized_keys }
%{ endfor ~}

# package_reboot_if_required: true
package_update: true
package_upgrade: true
packages:
  - docker-ce
  - docker-ce-cli
  - ack
  - apt-file
  - bash-completion
  - bat
  - bsdmainutils
  - ccze
  - certbot
  - colordiff
  - curl
  - eza
  - git
  - htop
  - jq
  - lftp
  - lynx
  - make
  - mc
  - mutt
  - net-tools
  - neofetch
  - nginx
  - psmisc
  - python3-certbot-nginx
  - rsync
  - sysstat
  - telnet
  - terraform
  - tmux
  - tree
  - wget
  - vim-nox

write_files:
%{ if scripts_repo_url != null && scripts_repo_url != "" ~}
  - path: /tmp/provision.sh
    permissions: '0755'
    content: |
      #!/bin/bash
      set -e
      set -x
      cd /opt
      git clone --depth 1 ${ scripts_repo_url } provision
      cd provision/scripts
      chmod +x *.sh
    owner: 'root:root'
    permissions: '0755'
    defer: true
%{ endif ~}

runcmd:
  - rm -f /etc/ssh/sshd_config.d/60-cloudimg-settings.conf
  - systemctl restart ssh
  - echo "Creating swap file..."
  - dd if=/dev/zero of=/swap bs=1MiB count=${ swap_size }
  - chmod 0600 /swap
  - mkswap /swap
  - swapon /swap
  - /tmp/provision.sh
  - /opt/provision/scripts/provision.sh %{ for user in users ~}${ user.name } %{ endfor ~}
  # - test -f /var/run/reboot-required && reboot
