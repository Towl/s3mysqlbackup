FROM alpine

RUN apk add mysql-client pv coreutils
RUN apk add aws-cli --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community

COPY backup.sh /root

RUN chmod a+x /root/backup.sh

WORKDIR /root
