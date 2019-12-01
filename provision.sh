#!/usr/bin/env bash

VM_NAME=$1

lxc launch images:fedora/31 $VM_NAME

lxc exec $VM_NAME -- bash << 'EOLXC'
set -x
sleep 5

USERNAME=pthomison

dnf update -y

dnf -y install \
sudo \
git \
cros-guest-tools \
docker \
python3 \
zsh \
bind-utils \
wget \
curl \
util-linux-user \
htop

useradd $USERNAME
groupadd wheel
usermod -aG wheel $USERNAME
usermod -aG docker $USERNAME

# passwordless sudo
sed -i 's|%wheel.*ALL=(ALL).*ALL.*$|%wheel ALL=(ALL) NOPASSWD: ALL|g' /etc/sudoers

# inject a password
#echo "r3dh4t1!" | passwd --stdin $USERNAME

systemctl unmask systemd-logind
loginctl enable-linger $USERNAME

systemctl enable cros-sftp

# disable selinux
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

echo "Set disable_coredump false" >> /etc/sudo.conf

sudo su - $USERNAME
systemctl --user enable sommelier@0 sommelier-x@0 sommelier@1 sommelier-x@1 cros-garcon cros-pulse-config
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
EOLXC








