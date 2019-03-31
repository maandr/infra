#!/bin/sh

yellow=$(tput setaf 3)
normal=$(tput sgr0)

script_dir=$(dirname $(readlink -f "$0"))
dc="${script_dir}/docker-compose-wrapper.sh"

printf "\n\n"
printf "${yellow}starting containers..${normal}\n"
$dc up -d

${script_dir}/status.sh