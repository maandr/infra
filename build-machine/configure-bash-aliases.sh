#!/usr/bin/env bash

blue=$(tput setaf 4)
normal=$(tput sgr0)

script_dir=$(dirname $(readlink -f "$0"))
INFRA_DIR="$(dirname ${script_dir})"

export INFRA_DIR
bash_aliases=$(envsubst < "./.bash_aliases")

printf "\n\n${blue}"
echo "${bash_aliases}"
printf "${normal}\n\n"

read -p "${blue}Would you like me to override your existing ~/.bash_aliases with the above? [y/N]${normal}" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "${bash_aliases}" > ~/.bash_aliases
fi

exit 0