#!/bin/bash

set -e

: "${DATE_FORMAT:=%Y-%m-%dT%H:%M:%SZ}"

OUT_DIR=/root/db_out
RCLONE_CMD="rclone --no-check-certificate"

# Suffix filename with DB type for clarity
DB_TYPE=${DB_TYPE:-MYSQL}

timestamp="$(/usr/bin/date +"$DATE_FORMAT")"

if [ "$DB_TYPE" = "SQLITE" ]; then
    OUT_FILE=sqlite-backup-"$timestamp".sqlite.gz
    echo "Creating sqlite backup $OUT_FILE"
    tmpfile="$OUT_DIR"/sqlite-backup-"$timestamp".sqlite
    mkdir -p "$OUT_DIR"
    sqlite3 "$DB_FILE" ".backup '$tmpfile'"
    gzip -c "$tmpfile" > "$OUT_DIR"/"$OUT_FILE"
    rm -f "$tmpfile"
else
    OUT_FILE=mysqldump-"$timestamp".mysql.gz
    DB_SELECTOR=${DB_NAME:---all-databases}
    echo "Creating mysql backup $OUT_FILE"
    # NOTE: column-statistics are not supported in mariadb, so disabled
    MYSQL_PWD=$DB_PASSWORD mysqldump --single-transaction \
            --column-statistics=0 \
            "$DB_SELECTOR" \
            -u "$DB_USER" -h "$DB_HOST" \
            | gzip > "$OUT_DIR"/"$OUT_FILE"
fi

echo "Uploading"
$RCLONE_CMD copy "$OUT_DIR" target:"$TARGET_BUCKET"
