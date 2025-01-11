#!/bin/bash

WIN_HOME=$(cygpath -u "${USERPROFILE}")
declare -A targets=(
    ["ohmyposh"]="${HOME}/.config/ohmyposh"
    [".gitconfig"]="${HOME}/.gitconfig"
    [".wezterm.lua"]="${WIN_HOME}/.wezterm.lua"
    [".zshrc"]="${HOME}/.zshrc"
)

for target in "${!targets[@]}"; do
    link=${targets[$target]}
    if [ -e "$link" ]; then
        echo "Symlink for $target already exists at $link. Skipping"
        continue
    fi
    target=$(dirname "$(realpath "$0")")/$target
    if [ -d "$target" ]; then
        link=$(cygpath -w "$link")
        target=$(cygpath -w "$target")
        cmd //c "mklink /D $link $target"
    elif [ -f "$target" ]; then
        link=$(cygpath -w "$link")
        target=$(cygpath -w "$target")
        cmd //c "mklink $link $target"
    else
        echo "Invalid target: $target"
    fi
done
echo "Installation completed."
