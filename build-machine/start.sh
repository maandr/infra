#!/bin/sh

yellow=$(tput setaf 3)
normal=$(tput sgr0)

script_dir=$(dirname $(readlink -f "$0"))
compose_file="${script_dir}/docker-compose.yml"



printf "\n\n"
printf "${yellow}starting containers..${normal}\n"
docker-compose --file ${compose_file} up -d

${script_dir}/status.sh