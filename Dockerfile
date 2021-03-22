FROM google/cloud-sdk

RUN apt install -y default-mysql-client pv

COPY backup.sh /tmp

RUN chmod a+x /tmp/backup.sh

WORKDIR /tmp
