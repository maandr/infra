#!/bin/sh

blue=$(tput setaf 4)
yellow=$(tput setaf 3)
green=$(tput setaf 2)
red=$(tput setaf 1)
normal=$(tput sgr0)

script_dir=$(dirname $(readlink -f "$0"))
project_dir="$(dirname ${script_dir})"

printf " ---------------------------------------\n"
printf " ${yellow}setup machine for infra${normal}\n"
printf " ---------------------------------------\n"

printf "\n\n"
printf "${yellow}add additional package repositories..${normal}\n"
CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

printf "\n\n"
printf "${yellow}updating package cache..${normal}\n"

apt-get update

printf "\n\n"
printf "${yellow}updating packages to latest versions..${normal}\n"

apt-get upgrade -y

# install dependencies
dependencies="git vim docker-ce make g++ google-cloud-sdk"
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
. ${project_dir}/.secrets

printf "\n\n"
printf "${yellow}initializing gcloud..${normal}\n"
gcloud init --console-only --project ${gcloud_project_id}

printf "\n\n"
printf "${yellow}generating database init scripts..${normal}\n"
./generate-initdb.sh

printf "\n\n"
printf "${yellow}starting infrastructure..${normal}\n"
./restart.sh

printf "\n\n"
printf "${yellow}waiting for all components to have finished startup..${normal}\n"
sleep 10
./status.sh

printf "\n\n"
printf "${yellow}fechting ssl-certificates with letsencrypt..${normal}\n"
./request-ssl-certificates.sh

printf "\n\n"
printf "${yellow}setup cronjobs..${normal}\n"
crontab -r
(crontab -l 2>/dev/null; echo "0 23 * * * ${script_dir}/renew-ssl-certificates.sh") | crontab -
(crontab -l 2>/dev/null; echo "0 4 * * * ${script_dir}/backup-mysql-databases.sh") | crontab -
crontab -l


printf "\n\n"
printf "${yellow}configure .bashrc..${normal}\n"
./configure-bashrc.sh

printf "\n\n"
printf "${green}success.${normal}\n"

exit 0