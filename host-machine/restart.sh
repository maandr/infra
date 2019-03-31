#!/bin/sh

yellow=$(tput setaf 3)
normal=$(tput sgr0)

script_dir=$(dirname $(readlink -f "$0"))

${script_dir}/stop.sh && ${script_dir}/start.sh