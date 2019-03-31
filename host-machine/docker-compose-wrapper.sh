#!/bin/sh

yellow=$(tput setaf 3)
normal=$(tput sgr0)

script_dir=$(dirname $(readlink -f "$0"))
compose_file="${script_dir}/docker-compose.yml"

docker-compose --file "${compose_file}" "$@"