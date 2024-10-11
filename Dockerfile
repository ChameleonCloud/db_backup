FROM ubuntu

RUN apt update && \
    apt install -y --no-install-recommends \
        curl \
        jq \
        inotify-tools \
        mysql-client \
        wget \
        unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget --no-check-certificate https://downloads.rclone.org/rclone-current-linux-amd64.zip
RUN unzip rclone-current-linux-amd64.zip
# Hacky way to get around the unknown extract directory (it's named for version)
RUN cp $(unzip -l rclone-current-linux-amd64.zip | awk '/\/$/ {print $4}' | head -n 1)/rclone /usr/bin/

# Installs supercronic, cron that works better for containers
# https://github.com/aptible/supercronic?tab=readme-ov-file
ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.2.33/supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=71b0d58cc53f6bd72cf2f293e09e294b79c666d8 \
    SUPERCRONIC=supercronic-linux-amd64

RUN curl -k -fsSLO "$SUPERCRONIC_URL" \
    && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
    && chmod +x "$SUPERCRONIC" \
    && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
    && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic


RUN touch /var/log/cron.log

COPY cron-schedule /cron-schedule

COPY run.sh .
COPY backup.sh /
COPY upload.sh /
COPY cleanup.sh /

CMD bash run.sh