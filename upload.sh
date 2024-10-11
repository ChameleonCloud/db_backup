#!/bin/bash

echo "Uploading"
rclone copy "$OUT_DIR" target:"$TARGET_BUCKET"