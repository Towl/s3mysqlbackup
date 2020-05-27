#!/bin/sh
mc config host add minio $MINIO_ENDPOINT $MINIO_ACCESS_KEY $MINIO_SECRET_KEY
mc ilm expiry set --days $BACKUP_LIFESPAN --prefix $PREFIX minio/$BUCKET
NOW="$(date +%Y-%m-%d_%Hh%Mm%S)"
mysqldump --verbose --hex-blob --complete-insert --single-transaction --skip-lock-tables --skip-add-locks --routines -u$MYSQL_USER -h$MYSQL_HOST -p$MYSQL_PASS --databases $MYSQL_DB | (pv -peartb | gzip - | mc pipe minio/$BUCKET/$PREFIX/$MYSQL_DB-$NOW.sql.gz)
