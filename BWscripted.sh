#!/bin/bash
username="admin"
password=$(timeout 1.5 bw generate) #timeout used because otherwise this command takes way too long for no reason
switch="\"Switch_$1\""

#see bitwarden scripting information for more about this
export BW_SESSION="$2"
echo $password
export $password

#create the Item in bitwarden
CreatedItem=$(bw get template item | jq ".name=$(echo $switch) | .creationDate=$(date --iso-8601) | .login=$(bw get template item.login | jq --arg user "$username" --arg pass "$password" '.username=$user | .password=$pass | del(.totp) | del(.fido2Credentials)')" | bw encode | bw create item)
echo $CreatedItem


id=$(echo $CreatedItem | jq -r '.id')


echo $id

organizationId="OBFUSCATED PUT YOUR ORG ID HERE"
echo '["OBFUSCATED PUT YOUR Group ID here"]' | bw encode | bw move $id $organizationId