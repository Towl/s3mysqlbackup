#!/bin/sh
mc config host add minio $MINIO_ENDPOINT $MINIO_ACCESS_KEY $MINIO_SECRET_KEY
NOW="$(date +%Y-%m-%d_%Hh%Mm%S)"
mysqldump --verbose --hex-blob --complete-insert --single-transaction --skip-lock-tables --skip-add-locks --routines -u$MYSQL_USER -h$MYSQL_HOST -p$MYSQL_PASS --databases $MYSQL_DB | (pv -peartb | gzip - | mc pipe minio/$BUCKET/$PREFIX/$MYSQL_DB-$NOW.sql.gz)

LIST_BACKUPS="$(mc ls minio/$BUCKET/$PREFIX | awk '{print $5}')"
NB_BACKUPS=$(echo $LIST_BACKUPS | wc -w)
echo "Currently $NB_BACKUPS are stored"
if [ ! -z "$MAX_BACKUPS" ] && [ $MAX_BACKUPS -gt "0" ]; then
  echo "Maximum number of $MAX_BACKUPS reached."
  while [ $NB_BACKUPS -gt $MAX_BACKUPS ]; do
    TO_BE_DELETED=$(echo $LIST_BACKUPS | awk '{print $1}')
    mc rm minio/$BUCKET/$PREFIX/$TO_BE_DELETED
    LIST_BACKUPS="$(mc ls minio/$BUCKET/$PREFIX/ | awk '{print $5}')"
    NB_BACKUPS=$(echo $LIST_BACKUPS | wc -w)
  done
fi
