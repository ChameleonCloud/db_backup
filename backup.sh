#!/bin/bash

echo "Creating backup"
mysqldump --all-databases -h "$DB_HOST" -p"$DB_PASSWORD" \
    --result-file="$OUT_DIR"/mysqldump-"$(/usr/bin/date +"%Y-%m-%d")".mysql 
