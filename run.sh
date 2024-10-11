#!/bin/bash

required_vars=("DB_PASSWORD" "DB_HOST" "RCLONE_CONFIG_JSON" "TARGET_BUCKET")
for var in "${required_vars[@]}"; do
  if [ -z "${!var}" ]; then
    echo "Error: Required variable $var is not set"
    exit 1
  fi
done

export OUT_DIR=/root/db_out
mkdir -p "$OUT_DIR"

# Create the config from passed in env
config_path=/root/.config/rclone/rclone.conf
mkdir -p /root/.config/rclone/
echo "[target]" >> $config_path
for json in $(echo "$RCLONE_CONFIG_JSON" | jq -c '. | to_entries | .[]'); do
	key=$(echo "$json" | jq -r .key)
	value=$(echo "$json" | jq -r .value)
	echo "$key = $value" >> $config_path
done

if ! rclone lsd target > /dev/null 2>&1; then
    echo "Rclone config invalid"
    exit 1
fi

# Create target bucket if not exists
rclone mkdir target:"$TARGET_BUCKET"

# Run cron
crond -f -d 8