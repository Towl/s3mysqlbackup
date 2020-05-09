#!/bin/sh
NOW="$(date +%Y-%m-%d_%Hh%Mm%S)"
mysqldump --verbose --hex-blob --complete-insert --single-transaction --skip-lock-tables --skip-add-locks --routines -u$MYSQL_USER -h$MYSQL_HOST -p$MYSQL_PASS --databases $MYSQL_DB | (pv -peartb | gzip - | aws s3 cp - s3://$AWS_ENDPOINT/$PREFIX/$MYSQL_DB-$NOW.sql.gz --expires $(date -d "+$BACKUP_LIFESPAN days" +%Y-%m-%dT%H:%M:%SZ))
