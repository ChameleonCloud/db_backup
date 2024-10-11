#!/bin/bash

echo "Creating backup"
mysqldump --single-transaction --all-databases \
    -h "$DB_HOST" -p"$DB_PASSWORD" \
    --result-file="$OUT_DIR"/mysqldump-"$(/usr/bin/date +"%Y-%m-%d")".mysql 
