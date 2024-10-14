#!/bin/bash

echo "Cleaning up local files"
cd "$OUT_DIR" || exit

: "${CLEANUP_KEEP_COUNT:=30}"
: "${CLEANUP_AGE_DAYS:=30}"

# Iterate over the oldest files, ignoring the most recent 30
for file in $(find . -type f -exec ls -t {} + | tail -n +"$CLEANUP_KEEP_COUNT"); do
    # If the file is more than 30 days old, remove it
    if find "$file" -type f -mtime +"$CLEANUP_AGE_DAYS" | grep -q "$file"; then
        echo "Deleting local file $file"
        rm "$file"

        # Check for remote file
        if $RCLONE_CMD ls target:"$TARGET_BUCKET"/"$file" | grep -q "$file"; then
            echo "Deleting remote file $file"
            $RCLONE_CMD deletefile target:"$TARGET_BUCKET"/"$file"
        fi
    fi
done
