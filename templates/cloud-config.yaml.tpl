#cloud-config
apt:
  sources :
    hashicorp:
      source: deb [signed-by=$KEY_FILE] https://apt.releases.hashicorp.com $RELEASE main
      keyid: 798AEC654E5C15428C8E42EEAA16FCBCA621E701

# Add groups to the system
# Adds the ubuntu group with members 'root' and 'sys'
# and the empty group hashicorp.
groups:
  - ubuntu: [root,sys]
  - hashicorp

# Add users to the system. Users are added after groups are added.
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

  # - name: terraform
  #   gecos: terraform
  #   shell: /bin/bash
  #   primary_group: hashicorp
  #   sudo: ALL=(ALL) NOPASSWD:ALL
  #   groups: users, admin
  #   lock_passwd: false
  #   plain_text_password: hunter2
  #   ssh_authorized_keys:
  #     - ssh-rsa AAAAHHHHHH



# Downloads the golang package
package_reboot_if_required: true
package_update: true
package_upgrade: true
packages:
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
  - rsync
  - sysstat
  - telnet
  - terraform
  - tmux
  - tree
  - wget
  - vim-nox

write_files:
- path: /etc/nginx/sites-available/default
  permissions: '0644'
  content: |
    server {
        listen 80 default_server;
        server_name _;
        return 444;
    }
  ower: 'nginx:nginx'
  permissions: '0644'
  defer: true
%{ if scripts_repo_url != null && scripts_repo_url != "" ~}
 - path: //tmpprovision.sh
  permissions: '0755'
  content: |
    #!/bin/bash
    set -e
    set -x
    cd /opt
    git clone ${ scripts_repo_url } scripts
    cd scripts
    chmod +x *.sh
    ./provision.sh
  owner: 'root:root'
  permissions: '0755'
  defer: true


%{ endif ~}

runcmd:
  - rm -f /etc/ssh/sshd_config.d/60-cloudimg-settings.conf
  - systemctl restart ssh
  - dd if=/dev/zero of=/swap bs=1MiB count=${ swap_size }
  - chmod 0600 /swap
  - mkswap /swap
  - swapon /swap
  - /opt/scripts/provision.sh %{ for user in users ~}${ user.name } %{ endfor ~}

