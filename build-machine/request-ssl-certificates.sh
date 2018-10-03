#!/usr/bin/env bash

script_dir=$(dirname $(readlink -f "$0"))
project_dir="$(dirname ${script_dir})"

docker run -it --rm \
    -v /docker-volumes/certs:/etc/letsencrypt \
    -v /docker-volumes/var/lib/letsencrypt:/var/lib/letsencrypt \
    -v /docker-volumes/var/log/letsencrypt:/var/log/letsencrypt \
    -v /static:/data/letsencrypt \
    certbot/certbot \
    certonly --webroot \
    --register-unsafely-without-email --agree-tos \
    --webroot-path=/data/letsencrypt \
    --staging \
    -d maandr.de \
    -d www.maandr.de

exit 0