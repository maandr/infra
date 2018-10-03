#!/bin/sh

yellow=$(tput setaf 3)
normal=$(tput sgr0)

script_dir=$(dirname $(readlink -f "$0"))
secrets_file="$(dirname ${script_dir})/.secrets"
compose_file="${script_dir}/docker-compose.yml"

. ${secrets_file}

export mysql_root_password && \
export concourse_db_database && \
export concourse_db_username && \
export concourse_db_password && \
export concourse_user_and_password && \
    docker-compose "$@"