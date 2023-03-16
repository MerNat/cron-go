FROM golang:alpine AS base_alpine

RUN apk add bash ca-certificates git gcc g++ libc-dev

WORKDIR /temp

ADD . /temp

RUN go build -v -o cron-job-service && mkdir /final \
    && cp -r /temp/cron-job-service /final

FROM alpine:3.17

RUN apk update && apk add ca-certificates \
    && rm -rf /var/cache/apk/*

RUN apk add --no-cache --upgrade bash

WORKDIR /usr/src/app

COPY --from=base_alpine /final /usr/src/app/

COPY crontab.txt /crontab.txt
COPY script.sh /script.sh
COPY entry.sh /entry.sh
# setting owners permissions to read, write and excute those two given files
RUN chmod 755 /script.sh /entry.sh
RUN /usr/bin/crontab /crontab.txt

CMD ["/entry.sh"]