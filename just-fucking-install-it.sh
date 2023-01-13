#!/bin/bash

if [[ "$(command -v ansible)" == "" ]]; then
    echo "Installing Ansible:"
    sudo apt update
    sudo apt install software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install --yes ansible
fi

if [[ "$(command -v git-crypt)" == "" ]]; then
    echo "Installing git-crypt..."
    sudo apt install git-crypt

    echo "Running git-crypt unlock..."
    git-crypt unlock
fi

cd "$(dirname "$0")/ansible" || exit
trap 'sudo chown -R "${USER}"."${USER}" ~/.netrc ~/.cache' EXIT
sudo touch ~/.netrc
sudo chown root.root ~/.netrc

sudo ansible-playbook -i inventory "${PLAYBOOK:-playbook.yml}" -e "path=${PATH}" -e "pwd=${PWD}" -e "actual_home=${HOME}" -e "actual_username=${USER}" $*

# Restore ownership of certain directories
sudo chown -R ${USER}.${USER} $HOME/.gradle

# These are hard to set via Ansible. Do it in a simpler way...
# gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "'<Ctrl>section'"
gsettings set org.gnome.desktop.wm.preferences mouse-button-modifier "'<Alt><Super>'"
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,maximize,minimize:'
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-seconds true
