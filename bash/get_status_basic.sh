#!/usr/bin/env bash

set -e

# This script was written by Christian Frahm.
# It is licensed under the 'Unlicensed' license.
# Say that 5 times fast.
# Do whatever you want with it.



#Colors------------
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
BOLD="\e[1m"
RESET="\e[0m"
#------------------

#Helpers----------------------------------------------
section() {
        echo -e "${BOLD}${CYAN}$1${RESET}"
}

kv() {
        printf "${GREEN}%-20s${RESET} %s\n" "$1" "$2"
}

section_end() {
        echo -e "\n${BOLD}${BLUE}==========${RESET}"
}
#------------------------------------------------------

#System Info
section "Pi System Info"
HOSTNAME=$(hostname)
UPTIME=$(uptime -p)
KERNAL=$(uname -r)
ARCH=$(uname -m)
MODEL=$(tr -d '\0' <proc/device-tree/model 2>/dev/null || echo "Unkown")
OS=$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')

kv "Hostname: " "$HOSTNAME"
kv "Model: " "$MODEL"
kv "OS: " "$OS"
kv "Kernal: " "$KERNAL"
kv "Architecture: " "$ARCH"
kv "Uptime: " "$UPTIME"
section_end
#End System Info

#CPU TEMP
section "Temperature"

if command -v vcgencmd >/dev/null 2>&1; then
        TEMP=$(vcgencmd measure_temp | cut -d= -f2)
        kv "CPU TEMP: " "$TEMP"
        section_end
else
        kv "CPU Temp: " "vcgencmd not found"
        section_end
fi
#End CPU TEMP

#Memory usage
section "Memory Usage (free -h)"
free -h
section_end
#End Memory Usage

#Disk
section "Disk Usage"
df -h / /boot 2>/dev/null || df -h
section_end
#End Disk

#Network
section "Network"

IP=$(hostname -I | awk '{print $1}')
GATEWAY=$(ip route | grep default | awk '{print $3}')

kv "Local IP:" "$IP"
kv "Gateway: " "$GATEWAY"
section_end
#End Network

#DNS Test
section "DNS Test"
if command -v dig >/dev/null 2>&1; then
        DIG_RESULT=$(dig google.com)

        DNS_IP=$(echo "$DIG_RESULT" | awk '/SERVER:/ {print $3}' | cut -d# -f1)
        DNS_RESULT=$(echo "$DIG_RESULT" | awk '$4=="A"{print $5; exit}')

        kv "google.com: " "$DNS_RESULT"
        kv "DNS Server: " "$DNS_IP"
else
        kv "dig: " "dnsutils not installed"
fi
section_end
#End DNS Test

#CPU Load
section "CPU Load"
cat /proc/loadavg
section_end
#End CPU Load

#Top Processes
section "Top Processes"
ps aux | sort -rk4 | head -n 6
section_end
#End Top Processes
