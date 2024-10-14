#!/bin/bash

set -e

: "${DATE_FORMAT:=%Y-%m-%dT%H:%M:%SZ}"

OUT_FILE=mysqldump-"$(/usr/bin/date +"$DATE_FORMAT")".mysql.gz

DB_SELECTOR=${DB_NAME:---all-databases}

echo "Creating backup $OUT_FILE"
# NOTE: column-statistics are not supported in mariadb, so disabled
MYSQL_PWD=$DB_PASSWORD mysqldump --single-transaction \
    --column-statistics=0 \
    "$DB_SELECTOR" \
    -u "$DB_USER" -h "$DB_HOST" \
    | gzip > "$OUT_DIR"/"$OUT_FILE"

echo "Uploading"
$RCLONE_CMD copy "$OUT_DIR" target:"$TARGET_BUCKET"
