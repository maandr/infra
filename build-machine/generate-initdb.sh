#!/usr/bin/env bash

script_dir=$(dirname $(readlink -f "$0"))
project_dir="$(dirname ${script_dir})"
mysql_config_dir="${script_dir}/config/mysql/"

candidates="$(${project_dir}/util/secret-value.sh mysql_generate_databases)"

statement=""

for pair in $(echo ${candidates} | tr "," "\n")
do
    candidate=$(echo $pair | cut -d':' -f 1)
    password=$(echo $pair | cut -d':' -f 2)

    statement="${statement} 
    CREATE DATABASE IF NOT EXISTS '${candidate}' CHARACTER SET 'utf8';
    CREATE USER IF NOT EXISTS '${candidate}'@'%';
    GRANT ALL PRIVILEGES ON ${candidate}.* TO '${candidate}'@'%' IDENTIFIED BY '${password}';
    "
done

echo "${statement}

    FLUSH PRIVILEGES;" > ${mysql_config_dir}/initdb/init-databases-and-users.sql

exit 0