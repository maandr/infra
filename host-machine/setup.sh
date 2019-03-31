#!/bin/sh

set -e

blue=$(tput setaf 4)
yellow=$(tput setaf 3)
green=$(tput setaf 2)
red=$(tput setaf 1)
normal=$(tput sgr0)

script_dir=$(dirname $(readlink -f "$0"))
project_dir="$(dirname ${script_dir})"

printf " ---------------------------------------\n"
printf " ${yellow}setup hostmachine${normal}\n"
printf " ---------------------------------------\n"

printf "\n\n"
printf "${yellow}install minimal dependencies..${normal}\n"
apt-get install -y sudo curl apt-transport-https gnupg2 ufw \
    software-properties-common ca-certificates libssl-dev make g++

printf "\n\n"
printf "${yellow}updating package cache..${normal}\n"

apt-get update

printf "\n\n"
printf "${yellow}add additional package repositories..${normal}\n"

# docker-ce
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

printf "\n\n"
printf "${yellow}updating package cache..${normal}\n"

apt-get update

printf "\n\n"
printf "${yellow}uninstall apache2 if exists..${normal}\n"

service apache2 stop
apt-get purge apache2 apache2-utils apache2.2-bin apache2-common
apt-get autoremove

printf "\n\n"
printf "${yellow}installing dependencies..${normal}\n"

dependencies="git vim docker-ce"
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

printf "\n\n"
printf "${yellow}installing docker-compose..${normal}\n"
if ! docker-compose --version > /dev/null 2>&1; then
    curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

printf "\n\n"
printf "${yellow}allowing connections on port 80 and 443..${normal}\n"
ufw enable
ufw allow ssh
ufw allow http
ufw allow https
ufw allow 3306
ufw status