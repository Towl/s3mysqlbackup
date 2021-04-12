FROM google/cloud-sdk:alpine

RUN apk add mysql-client pv coreutils

COPY backup.sh /tmp
COPY restore.sh /tmp

RUN chmod a+x /tmp/backup.sh /tmp/restore.sh

WORKDIR /tmp
