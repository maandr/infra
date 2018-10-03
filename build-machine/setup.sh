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
dependencies="git vim docker-ce make g++"
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
curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

printf "\ninstalled version: "
docker-compose --version

printf "\n\n"
printf "${yellow}installing git-crypt..${normal}\n"
git clone https://www.agwa.name/git/git-crypt.git
cd git-crypt
make
make install
cd ..
rm -rf git-crypt
printf "\ninstalled version: "
git-crypt --version

printf "\n\n"
printf "${yellow}generating concourse keys..${normal}\n"
./generate-keys.sh

printf "\n\n"
printf "${yellow}unlocking repository..${normal}\n"
git-crypt unlock ~/.ssh/infra.key

printf "\n\n"
printf "${green}success.${normal}\n"

exit 0