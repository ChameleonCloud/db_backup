# DB_BACKUP

A container utility to backup a database to any rclone target.

Currently only supports mysql database backends.

## Configuration
Required values:
- `DB_USER`: DB user
- `DB_PASSWORD`: DB password
- `DB_HOST`: DB host
- `RCLONE_CONFIG_JSON`: The output of `rclone config dump | jq -c .my_source`
- `TARGET_BUCKET`: The bucket/directory to upload backups to

Optional configuration:
- `DB_NAME`: If specified, backup this DB. Otherwise backups all databases.
- `CLEANUP_KEEP_COUNT`: Always keep at least this many backups. Default 30
- `CLEANUP_AGE_DAYS`: Ignoring the most recent `$CLEANUP_KEEP_COUNT`many files, delete files older than this many days. Default 30.
- `DATE_FORMAT`: The date format to use in the backup filename. Defaults to `%Y-%m-%dT%H:%M:%SZ`

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

To save backups locally, mount a local directory to `/root/db_out`.

To manually create a backup, exec `/backup.sh`.
