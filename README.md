# DB_BACKUP

Add to docker-compose.yml:

```yaml
db_backup:
  image: ghcr.io/chameleoncloud/db_backup:latest
  restart: always
  environment:
    DB_PASSWORD:
    DB_HOST:
    RCLONE_CONFIG_JSON: # output of `rclone config dump | jq -c .my_source`
    TARGET_BUCKET: # Bucket to upload db backups to
```
