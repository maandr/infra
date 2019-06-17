#!/usr/bin/env bash

script_dir=$(dirname $(readlink -f "$0"))
project_dir="$(dirname ${script_dir})"

blue=$(tput setaf 4)
yellow=$(tput setaf 3)
green=$(tput setaf 2)
red=$(tput setaf 1)
normal=$(tput sgr0)

printf "\n\n"
printf "${yellow}disable nginx ssl.conf..${normal}\n"
mv ${script_dir}/config/nginx/ssl/weidelandschaften.de.conf ${script_dir}/config/nginx/ssl/.weidelandschaften.de.conf
mv ${script_dir}/config/nginx/ssl/etiketten.weidelandschaften.de.conf ${script_dir}/config/nginx/ssl/.etiketten.weidelandschaften.de.conf

printf "\n\n"
printf "${yellow}starting infrastructure..${normal}\n"
./restart.sh

printf "\n\n"
printf "${yellow}fechting ssl-certificates with letsencrypt..${normal}\n"
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

printf "\n\n"
printf "${yellow}enable nginx ssl.conf..${normal}\n"
mv ${script_dir}/config/nginx/ssl/.weidelandschaften.de.conf ${script_dir}/config/nginx/ssl/weidelandschaften.de.conf
mv ${script_dir}/config/nginx/ssl/.etiketten.weidelandschaften.de.conf ${script_dir}/config/nginx/ssl/etiketten.weidelandschaften.de.conf
./restart.sh
