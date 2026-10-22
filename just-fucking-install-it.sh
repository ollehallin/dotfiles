#!/bin/bash

if [[ "$(find /usr/local/bin -name 'ansible*' | wc -l)" -gt 0 ]]; then
    echo "Removing non-APT Ansible from /usr/local/bin/ ..."
    sudo rm /usr/local/bin/ansible*
fi

if [[ "$(command -v ansible)" == "" ]]; then
    echo "Installing Ansible:"
    sudo apt update
    # sudo apt install software-properties-common
    # sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install --yes ansible-core
fi

if [[ "$(command -v git-crypt)" == "" ]]; then
    echo "Installing git-crypt..."
    sudo apt install git-crypt

    echo "Running git-crypt unlock..."
    git-crypt unlock
fi

cd "$(dirname "$0")/ansible" || exit
trap 'sudo chown -R "${USER}":"${USER}" ~/.netrc ~/.cache' EXIT
sudo touch ~/.netrc
sudo chown root:root ~/.netrc

sudo ansible-playbook -i inventory "${PLAYBOOK:-playbook.yml}" -e "path=${PATH}" -e "pwd=${PWD}" -e "actual_home=${HOME}" -e "actual_username=${USER}" $*

# Restore ownership of certain directories
sudo chown -R ${USER}:${USER} $HOME/.gradle

# These are hard to set via Ansible. Do it in a simpler way...
# gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "'<Ctrl>section'"
gsettings set org.gnome.desktop.wm.preferences mouse-button-modifier "'<Alt><Super>'"
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,maximize,minimize:'
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-seconds true

# Install a custom key binding for doing xdg-open for what is in the clipboard
#!/bin/bash
PATH_SHORTCUT="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
SCHEMA_SHORTCUT="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$PATH_SHORTCUT"

# Configure the shortcut to point to the renamed script
gsettings set "$SCHEMA_SHORTCUT" name 'Open Geo from clipboard'
gsettings set "$SCHEMA_SHORTCUT" command '/usr/local/bin/open-geo-link'
gsettings set "$SCHEMA_SHORTCUT" binding '<Super>g'

# Append to the list of active custom shortcuts without overwriting existing ones
CURRENT_BINDINGS=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
if [[ "$CURRENT_BINDINGS" == "@as []" || "$CURRENT_BINDINGS" == "[]" ]]; then
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['$PATH_SHORTCUT']"
elif [[ "$CURRENT_BINDINGS" != *"$PATH_SHORTCUT"* ]]; then
    NEW_BINDINGS=$(echo "$CURRENT_BINDINGS" | sed "s|\]|, '$PATH_SHORTCUT'\]|")
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$NEW_BINDINGS"
fi

echo "Super+G now utilize the 'open-geo-link' script."
