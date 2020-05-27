---
Here is an example of a cronjob for Kubernetes using this container :

```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: wordpress-db-backup
spec:
  schedule: "0 3 * * *"
  concurrencyPolicy: Forbid
  successfulJobsHistoryLimit: 2
  failedJobsHistoryLimit: 2
  jobTemplate:
    spec:
      ttlSecondsAfterFinished: 259200
      template:
        spec:
          containers:
          - name: s3backup
            image: towl/s3mysqlbackup
            command: ["./backup.sh"]
            env:
              # The bucket name
              - name: MINIO_ENDPOINT
                value: towl-wordpress-backups
              - name: BUCKET
                value: bucket
              # The parent folder path in the bucket
              - name: PREFIX
                value: path
              # The lifespan in the S3
              - name: BACKUP_LIFESPAN
                value: "7"
              - name: MINIO_ACCESS_KEY
                valueFrom:
                  secretKeyRef:
                    name: minio-backup-secrets
                    key: access_key
              - name: MINIO_SECRET_KEY
                valueFrom:
                  secretKeyRef:
                    name: minio-backup-secrets
                    key: access_secret
              - name: MYSQL_HOST
                value: mysql.hostname
              - name: MYSQL_USER
                value: mysql.username
              - name: MYSQL_DB
                value: mysql.dbname
              - name: MYSQL_PASS
                valueFrom:
                  secretKeyRef:
                    name: mysql.secret
                    key: mariadb-root-password
          restartPolicy: OnFailure
```
