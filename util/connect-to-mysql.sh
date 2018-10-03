#!/bin/sh

yellow=$(tput setaf 3)
normal=$(tput sgr0)

script_dir=$(cd "$(dirname "$0")" && pwd)
project_dir=$(dirname ${script_dir})

. ${project_dir}/.secrets

mysql --host=${mysql_hostname} \
    --user=${mysql_username} \
    --password=${mysql_password}