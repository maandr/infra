#!/bin/sh
script_dir=$(dirname "$0")
project_dir=$(dirname "$script_dir")
echo $(cat ${project_dir}/.secrets | grep "$1" | cut -d'=' -f 2)