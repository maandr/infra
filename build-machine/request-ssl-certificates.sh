#!/usr/bin/env bash

yellow=$(tput setaf 3)
normal=$(tput sgr0)

script_dir=$(dirname $(readlink -f "$0"))
project_dir="$(dirname ${script_dir})"

letsencrypt_admin_email=$($project_dir/util/secret-value.sh letsencrypt_admin_email)

printf "\n\n"
printf "${yellow}requesting ssl certificates..${normal}\n"

docker run -it --rm \
    -v /docker-volumes/certs:/etc/letsencrypt \
    -v /docker-volumes/var/lib/letsencrypt:/var/lib/letsencrypt \
    -v /docker-volumes/var/log/letsencrypt:/var/log/letsencrypt \
    -v ${script_dir}/static:/static \
    certbot/certbot \
    certonly \
    --webroot \
    --email ${letsencrypt_admin_email} --agree-tos \
    --webroot-path=/static \
    -d maandr.de \
    -d www.maandr.de \
    -d ci.maandr.de

exit 0