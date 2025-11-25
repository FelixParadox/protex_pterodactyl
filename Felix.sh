#!/bin/bash

# Color
BLUE='\033[0;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Display welcome message
display_welcome() {
  echo -e ""
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                                                 [+]${NC}"
  echo -e "${BLUE}[+]              AUTO INSTALLER PARADOX             [+]${NC}"
  echo -e "${BLUE}[+]                   © Felix Paradox               [+]${NC}"
  echo -e "${BLUE}[+]                                                 [+]${NC}"
  echo -e "${RED}[+] =============================================== [+]${NC}"
  echo -e ""
  sleep 3
  clear
}

# Update and install jq
install_jq() {
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                INSTALLING JQ...                [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  sudo apt update && sudo apt install -y jq
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}[✓] JQ BERHASIL DIINSTALL${NC}"
  else
    echo -e "${RED}[✗] GAGAL INSTALL JQ${NC}"
    exit 1
  fi
  sleep 1
  clear
}

# Token Check
check_token() {
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]               FELIX AKSES TOKEN                [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e ""

  echo -e "${YELLOW}Masukkan Token / Password Akses:${NC}"
  read -r USER_TOKEN

  RAW_URL="https://raw.githubusercontent.com/sandyparadox59-alt/felixbetates/refs/heads/main/gmbs/gg.json"

  json=$(curl -fsS --max-time 10 "$RAW_URL") || json=""
  if [ -z "$json" ]; then
    echo -e "${RED}❌ Gagal mengakses server token.${NC}"
    exit 1
  fi

  valid=$(echo "$json" | jq -r --arg t "$USER_TOKEN" '.tokens[] | select(. == $t)')
  if [ -n "$valid" ]; then
    echo -e "${GREEN}✓ Token Valid — Akses diberikan.${NC}"
  else
    echo -e "${RED}Token Salah!${NC}"
    exit 1
  fi

  sleep 1
  clear
}

# Install Protex
install_protex() {
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                INSTALL PROTEX V1               [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"

  wget -O /root/ProtexV1.zip https://github.com/FelixParadox/protex_pterodactyl/raw/main/ProtexV1.zip
  unzip /root/ProtexV1.zip -d /root/pterodactyl

  sudo cp -rfT /root/pterodactyl /var/www/pterodactyl

  curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
  sudo apt install -y nodejs
  sudo npm i -g yarn

  cd /var/www/pterodactyl

  yarn add react-feather

  # Auto YES on production
  php artisan migrate --force
  yarn build:production
  php artisan view:clear

  sudo rm /root/ProtexV1.zip
  sudo rm -rf /root/pterodactyl

  echo -e "${GREEN}[✓] PROTEX BERHASIL DIINSTALL${NC}"
  sleep 2
  clear
}

# Uninstall Protex
uninstall_protex() {
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]              UNINSTALL PROTEX PANEL             [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"

  bash <(curl -s https://raw.githubusercontent.com/gitfdil1248/thema/main/repair.sh)

  echo -e "${GREEN}[✓] PROTEX BERHASIL DIHAPUS${NC}"
  sleep 2
  clear
}

# MAIN MENU
display_welcome
install_jq
check_token

while true; do
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo -e "${BLUE}[+]                 FELIX PARADOX MENU              [+]${NC}"
  echo -e "${BLUE}[+] =============================================== [+]${NC}"
  echo ""
  echo "1. Install Protex"
  echo "2. Uninstall Protex"
  echo "3. Exit"
  echo ""
  read -p "Masukkan pilihan: " MENU_CHOICE
  clear

  case "$MENU_CHOICE" in
    1) install_protex ;;
    2) uninstall_protex ;;
    3) echo "Keluar."; exit 0 ;;
    *) echo -e "${RED}Pilihan tidak valid!${NC}" ;;
  esac
done
