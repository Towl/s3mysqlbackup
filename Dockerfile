FROM alpine

RUN apk add mysql-client pv coreutils wget
RUN wgt https://dl.min.io/client/mc/release/linux-amd64/mc -O /bin
RUN chmod a+x /bin/mc

COPY backup.sh /root

RUN chmod a+x /root/backup.sh

WORKDIR /root
