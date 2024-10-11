FROM ubuntu

RUN apt update && \
    apt install -y --no-install-recommends \
        cron \
        jq \
        inotify-tools \
        mysql-client \
        wget \
        unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://downloads.rclone.org/rclone-current-linux-amd64.zip
RUN unzip rclone-current-linux-amd64.zip
RUN cp rclone-current-linux-amd64/rclone /usr/bin/

RUN touch /var/log/cron.log

COPY cron-schedule /etc/cron.d/cron-schedule
COPY run.sh .
COPY backup.sh /
COPY upload.sh /
COPY cleanup.sh /

CMD bash run.sh