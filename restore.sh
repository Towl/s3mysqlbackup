#!/bin/bash
echo "==> Installing dump from gs://$BUCKET/$PREFIX/$ARCHIVE_RESTORE"
gsutil cp gs://$BUCKET/$PREFIX/$ARCHIVE_RESTORE - | gzip -d - | pv -peartb | mysql --ssl --ssl-key=/etc/mysql/certs/client-key.pem --ssl-cert=/etc/mysql/certs/client-cert.pem -u$MYSQL_USER -h$MYSQL_HOST -p$MYSQL_PASS $MYSQL_DB
echo "==> Done"
