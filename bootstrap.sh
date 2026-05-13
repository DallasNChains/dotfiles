#!/usr/bin/env bash
set -euxo pipefail

if ! command -v chezmoi &>/dev/null; then
    echo "Installing chezmoi..."
    sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init --apply DallasNChains
else
    echo "chezmoi already installed. Applying..."
    chezmoi apply
fi