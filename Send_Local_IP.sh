#!/usr/bin/env bash

set -euo pipefail

WEBHOOK_URL="YOUR_WEBHOOK_HERE"

for i in {1..30}; do
    if ping -c1 -W1 discord.com &>/dev/null; then
        break
    fi
    sleep 1
done

if ! ping -c1 -W3 discord.com &>/dev/null; then
    echo "discord.com not responding"
    exit 1
fi

IP=$(hostname -I | awk '{print $1}')

if [ -z "$IP" ]; then
    echo "No IP address?"
    exit 1
fi

payload=$(jq -n --arg ip "$IP" '{content: "@everyone LOCAL IP: **\($ip)**"}')

curl -sS -H "Content-Type: application/json" -X POST -d "$payload" "$WEBHOOK_URL"
