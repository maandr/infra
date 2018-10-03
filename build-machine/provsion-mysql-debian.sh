#!/bin/sh

yellow=$(tput setaf 3)
normal=$(tput sgr0)

script_dir=$(cd "$(dirname "$0")" && pwd)
project_dir=$(dirname "${script_dir}")

. ${project_dir}/.secrets

printf "\n\n"
printf "${yellow}uninstall any existing mysql packages..${normal}"
apt-get remove -y --purge mysql\*
apt-get clean

printf "\n\n"
printf "${yellow}install mysql-client..${normal}"
apt-get install -y libmysqlclient-dev mysql-client

printf "\n\n"
printf "${yellow}install mysql-server..${normal}"
echo "mysql-server mysql-server/root_password password ${mysql_root_password}" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password ${mysql_root_password}" | debconf-set-selections
apt-get install -y mysql-server
mysql --version

printf "\n\n"
printf "${yellow}testing mysql service..${normal}"
systemctl status mysql.service

printf "\n\n"
printf "${yellow}securing mysql-server..${normal}"

mysql -u ${mysql_root_user} -p${mysql_root_password} \
    -e " \
        DROP USER ''@'localhost'; \
        DROP USER ''@'$(hostname)'; \
        DROP DATABASE test; \
        FLUSH PRIVILEGES; \
    "

printf "\n\n"
printf "${yellow}connect to mysql service..${normal}"
printf "\n"
mysql -u ${mysql_root_user} -p${mysql_root_password} \
    -e "SELECT host, user from mysql.user;"

printf "\n\n"
printf "${yellow}verifying port 3306 is open..${normal}"
ufw allow 3306
nc -vz ${mysql_hostname} ${mysql_port}