#!/usr/bin/env bash

script_dir=$(dirname $(readlink -f "$0"))
project_dir="$(dirname ${script_dir})"

. ${project_dir}/.secrets

datetime=`date "+%d-%m-%Y-%H-%M-%S"`

docker exec mysql \
    sh -c "exec mysqldump --all-databases -uroot -p${mysql_root_password} \
    | gzip > /var/lib/mysql/dumps/date ${datetime}.sql.gz"