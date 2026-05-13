#!/usr/bin/env bash
set -euxo pipefail

if ! command -v chezmoi &>/dev/null; then
    echo "Installing chezmoi..."
    sudo sh -c "$(curl -fsLS get.chezmoi.io)" -- init -b /usr/local/bin --apply DallasNChains
else
    echo "chezmoi already installed. Applying..."
    chezmoi apply
fi