#!/bin/sh

blue=$(tput setaf 4)
yellow=$(tput setaf 3)
green=$(tput setaf 2)
red=$(tput setaf 1)
normal=$(tput sgr0)

printf " ---------------------------------------\n"
printf " ${yellow}setup machine for infra${normal}\n"
printf " ---------------------------------------\n"

printf "\n\n"
printf "${yellow}updating package cache..${normal}\n"

apt-get update

printf "\n\n"
printf "${yellow}updating packages to latest versions..${normal}\n"

apt-get upgrade -y

# install dependencies
dependencies="git git-crypt vim docker.io docker-compose"
for app in ${dependencies}
do
    printf "\n\n"
    printf "${yellow}installing ${app}..${normal}\n"
    apt-get install -y ${app}
    if ${app} --version > /dev/null 2>&1; then
        printf "\ninstalled version: "
        ${app} --version
    fi
done