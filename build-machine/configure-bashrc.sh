#!/usr/bin/env bash

blue=$(tput setaf 4)
normal=$(tput sgr0)

script_dir=$(dirname $(readlink -f "$0"))

export INFRA_DIR="$(dirname ${script_dir})"
export BUILD_MACHINE_DIR="${INFRA_DIR}/build-machine"

bash_aliases=$(envsubst < "./.bashrc")

printf "\n\n${blue}"
echo "${bash_aliases}"
printf "${normal}\n\n"

read -p "${blue}Would you like me to override your existing ~/.bashrc with the above? [y/N]${normal}" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "${bash_aliases}" > ~/.bashrc
fi

exit 0