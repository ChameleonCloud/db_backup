#!/bin/bash

echo "Cleaning up local files"
cd "$OUT_DIR" || exit
# Iterate over the oldest files, ignoring the most recent 30
for file in $(find . -type f -exec ls -t {} + | tail -n +30); do
    # If the file is more than 30 days old, remove it
    if find "$file" -type f -mtime +30 | grep -q "$file"; then
        echo "Deleting local file $file"
        rm "$file"

        # Check for remote file
        if $RCLONE_CMD ls target:"$TARGET_BUCKET"/"$file" | grep -q "$file"; then
            echo "Deleting remote file $file"
            $RCLONE_CMD deletefile target:"$TARGET_BUCKET"/"$file"
        fi
    fi
done
