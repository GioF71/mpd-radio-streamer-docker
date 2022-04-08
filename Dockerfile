ARG BASE_IMAGE
FROM ${BASE_IMAGE} AS base

RUN apt-get update && apt-get install mpc -y && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.mpd

RUN mkdir -p /db
RUN mkdir -p /music
RUN mkdir -p /playlists

RUN mkdir /app/bin -p
RUN mkdir /app/assets -p
RUN mkdir /app/conf -p

COPY app/assets/mpd-template.conf /app/assets/

#EXPOSE 6600
EXPOSE 8000

ENV MPD_RADIO_STREAMER_HTTPD_ALWAYS_ON ""
ENV MPD_RADIO_STREAMER_HTTPD_TAGS ""

ENV MPD_RADIO_STREAMER_URL ""
ENV MPD_RADIO_STREAMER_NAME ""

ENV STARTUP_DELAY_SEC 0

COPY app/bin/run-mpd.sh /app/bin/run-mpd.sh
RUN chmod 755 /app/bin/run-mpd.sh
RUN chmod 755 /app/assets

RUN mkdir -p /app/doc
COPY README.md /app/doc/

ENTRYPOINT ["/app/bin/run-mpd.sh"]
