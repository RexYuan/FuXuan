#!/bin/bash

SECRET=$(dirname $(realpath "$0"))/secret.sh
[ -e "$SECRET" ] || (echo "secret.sh does not exist."; exit 1)
. $SECRET

CURRENT_IP=$(curl -s http://ipv4.icanhazip.com)
DNS_IP=$(dig +short "${URLS[0]}" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | awk 'NR==1{print}')

if [ "$CURRENT_IP" != "$DNS_IP" ]; then
    echo "Renew IP: $DNS_IP to $CURRENT_IP"
    for ((i = 0; i < ${#URLS[@]}; i++)); do
        curl --request PUT \
            --url "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/${RECORD_IDS[$i]}" \
            --header "Content-Type: application/json" \
            --header "X-Auth-Email: $EMAIL" \
            --header "Authorization: Bearer $KEY" \
            --data "{
        \"type\": \"A\",
        \"name\": \"${URLS[$i]}\",
        \"content\": \"$CURRENT_IP\"
        }"
    done
else
    echo "No change: $CURRENT_IP"
fi
