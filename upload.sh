#!/bin/bash

echo "Uploading"
$RCLONE_CMD copy "$OUT_DIR" target:"$TARGET_BUCKET"
