#!/bin/bash

declare -A targets=(
    [".zshrc"]="${HOME}/.zshrc"
    ["ohmyposh"]="${HOME}/.config/ohmyposh"
)

# echo "$USERPROFILE"
# echo "$HOMEPATH"
# echo "$HOMEDRIVE"
# echo "$APPDATA"
# echo "$LOCALAPPDATA"

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
