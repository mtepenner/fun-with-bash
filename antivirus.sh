#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (sudo)."
   exit 1
fi

echo "--- Starting Security & Malware Scan ---"

## 1. Check for ClamAV
if ! command -v clamscan &> /dev/null; then
    echo "[!] ClamAV not found. Installing..."
    apt-get update && apt-get install -y clamav clamav-daemon
fi

## 2. Update Virus Definitions
echo "[*] Updating virus signatures..."
systemctl stop clamav-freshclam
freshclam
systemctl start clamav-freshclam

## 3. Perform Malware Scan
# Scans /home and /tmp (common targets) and moves infected files to a quarantine folder
QUARANTINE_DIR="/tmp/quarantine"
mkdir -p $QUARANTINE_DIR

echo "[*] Scanning /home and /tmp for malware..."
clamscan -r --bell -i --move=$QUARANTINE_DIR /home /tmp /var/www

## 4. Check for Suspicious Network Connections
echo "[*] Checking for suspicious listening ports..."
# Lists all open ports and the programs using them
netstat -tulpn | grep LISTEN

## 5. Check for Rootkits
if command -v rkhunter &> /dev/null; then
    echo "[*] Running Rootkit Hunter..."
    rkhunter --check --sk
else
    echo "[i] Tip: Install 'rkhunter' for deeper kernel-level checks."
fi

echo "--- Scan Complete ---"
echo "Infected files (if any) moved to: $QUARANTINE_DIR"
