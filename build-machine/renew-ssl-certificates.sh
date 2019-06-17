#!/usr/bin/env bash

script_dir=$(dirname $(readlink -f "$0"))
project_dir="$(dirname ${script_dir})"

docker run -it --rm \
    --name certbot \
    -v /docker-volumes/certs:/etc/letsencrypt \
    -v /docker-volumes/var/lib/letsencrypt:/var/lib/letsencrypt \
    -v /docker-volumes/var/log/letsencrypt:/var/log/letsencrypt \
    -v ${script_dir}/static:/static \
    certbot/certbot \
    renew \
    --webroot \
    --webroot-path=/static \
    --quiet \
    && docker kill --signal=HUP reverse-proxy