#!/bin/bash

set -e

: "${DATE_FORMAT:=%Y-%m-%dT%H:%M:%SZ}"

OUT_FILE=mysqldump-"$(/usr/bin/date +"$DATE_FORMAT")".mysql.gz

echo "Creating backup $OUT_FILE"
MYSQL_PWD=$DB_PASSWORD mysqldump --single-transaction --all-databases \
    -h "$DB_HOST" \
    | gzip > "$OUT_DIR"/"$OUT_FILE"

echo "Uploading"
$RCLONE_CMD copy "$OUT_DIR" target:"$TARGET_BUCKET"
