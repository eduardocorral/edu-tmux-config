#!/usr/bin/env bash
basedir=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
defaultTmuxConf="${HOME}/.tmux.conf"
tmuxConfDir="${HOME}/.tmux"
tmuxPluginsDir="${tmuxConfDir}/plugins"
export TMUX_PLUGIN_MANAGER_PATH="${tmuxPluginsDir}"

mkdir -p "${tmuxConfDir}"
if [ -f "${defaultTmuxConf}" ]; then
    echo "Backing up existing tmux config to ${defaultTmuxConf}.bak"
    mv "${defaultTmuxConf}" "${defaultTmuxConf}.bak"
fi

ln -vs "${basedir}/.tmux.conf" "${defaultTmuxConf}"

# See https://github.com/tmux-plugins/tpm/blob/master/docs/automatic_tpm_installation.md
if [ -d "${tmuxPluginsDir}/tpm" ]; then
    echo "tmux plugin manager already exists, skipping installation"
else
    echo "Installing tmux plugin manager (tpm) to ${tmuxPluginsDir}/tpm"
    git clone https://github.com/tmux-plugins/tpm "${tmuxPluginsDir}/tpm"
fi

echo "Installing dependencies"
if command -v apt-get &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y fonts-noto-color-emoji bc jq
elif command -v brew &> /dev/null; then
    brew install noto-fonts-nerd-font bc jq
else
    echo "Unsupported OS, please install dependencies manually: fonts-noto-color-emoji, bc, jq"
fi

echo "Installing plugins"
"${tmuxPluginsDir}/tpm/bin/install_plugins"

echo "tmux ready"


