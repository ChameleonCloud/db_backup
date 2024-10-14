#!/bin/bash

set -e

: "${DATE_FORMAT:=%Y-%m-%dT%H:%M:%SZ}"

OUT_FILE=mysqldump-"$(/usr/bin/date +"$DATE_FORMAT")".mysql.gz

echo "Creating backup $OUT_FILE"
# NOTE: column-statistics are not supported in mariadb, so disabled
MYSQL_PWD=$DB_PASSWORD mysqldump --single-transaction --all-databases \
    --column-statistics=0 \
    -u "$DB_USER" -h "$DB_HOST" \
    | gzip > "$OUT_DIR"/"$OUT_FILE"

echo "Uploading"
$RCLONE_CMD copy "$OUT_DIR" target:"$TARGET_BUCKET"
