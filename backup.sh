#!/bin/bash
VERSIONING_ENABLED=$(gsutil versioning get gs://$BUCKET/ | grep Enabled)
BUCKET_ARCHIVE_NAME=$ARCHIVE_NAME.sql.gz
if [ "$VERSIONING_ENABLED" == "" ];then
  echo "==> Add datetime in archive name (use versioning on the bucket if you want to remove it)"
  NOW="$(date +%Y-%m-%d_%Hh%Mm%S)"
  BUCKET_ARCHIVE_NAME=$ARCHIVE_NAME-$NOW.sql.gz
else
  echo "==> Versioning enabled on bucket. Use same archive name for all backup"
fi

echo "==> Generating dump in gs://$BUCKET/$PREFIX/$BUCKET_ARCHIVE_NAME"
mysqldump --ssl --ssl-key=/etc/mysql/certs/client-key.pem --ssl-cert=/etc/mysql/certs/client-cert.pem --hex-blob --complete-insert --single-transaction --skip-lock-tables --skip-add-locks --routines -u$MYSQL_USER -h$MYSQL_HOST -p$MYSQL_PASS --databases $MYSQL_DB | gzip - | gsutil cp - gs://$BUCKET/$PREFIX/$BUCKET_ARCHIVE_NAME

echo "==> Done"
