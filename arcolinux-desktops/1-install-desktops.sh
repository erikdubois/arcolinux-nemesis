#!/bin/bash

# Check for dialog or whiptail
DIALOG=$(command -v dialog || command -v whiptail)
[ -z "$DIALOG" ] && { echo "dialog or whiptail required"; exit 1; }

# Collect scripts excluding those starting with '1'
scripts=()
for file in *.sh; do
    [[ -f $file && $(basename "$file") != 1* ]] && scripts+=( "$file" )
done

# Exit if no scripts found
[ ${#scripts[@]} -eq 0 ] && { echo "No install scripts found."; exit 1; }

# Build menu options
menu_items=()
for script in "${scripts[@]}"; do
    menu_items+=( "$script" "" off )
done

# Show checklist
choices=$(
    $DIALOG --separate-output --checklist "Select desktop(s) to install:" 20 70 15 \
    "${menu_items[@]}" 3>&1 1>&2 2>&3
)

# Handle cancel
[ $? -ne 0 ] && echo "Installation canceled." && exit 1

# Execute selected scripts
for choice in $choices; do
    echo "Executing $choice..."
    bash "$choice"
done
