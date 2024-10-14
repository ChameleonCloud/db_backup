# DB_BACKUP

A container utility to backup a database to any rclone target.

Currently only supports mysql database backends.

## Configuration
Required values:
- `DB_PASSWORD`: Root DB password
- `DB_HOST`: DB host
- `RCLONE_CONFIG_JSON`: The output of `rclone config dump | jq -c .my_source`
- `TARGET_BUCKET`: The bucket/directory to upload backups to

Optional configuration:
- `CLEANUP_KEEP_COUNT`: Always keep at least this many backups
- `CLEANUP_AGE_DAYS`: Ignoring the most recent `$CLEANUP_KEEP_COUNT`many files, delete files older than this many days

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
