#!/bin/sh

-e # Exit immediately if a command exits with a non-zero status.

yellow=$(tput setaf 3)
normal=$(tput sgr0)

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

pushd ${script_dir} > /dev/null

    source ../.secrets

    printf "\n\n"
    printf "${yellow}uninstall any existing mysql packages..${normal}"
    apt-get remove --purge mysql\*
    apt-get clean
    updatedb

    printf "\n\n"
    printf "${yellow}install mysql-client..${normal}"
    apt-get install -y libmysqlclient-dev mysql-client

    printf "\n\n"
    printf "${yellow}install mysql-server..${normal}"
    spt-get update
    apt-get install -y mysql-server-5.6
    mysql --version

    printf "\n\n"
    printf "${yellow}securing mysql-server..${normal}"

    mysql -e "UPDATE mysql.user SET Password = PASSWORD('${mysql_password}') WHERE User = 'root'"
    mysql -e "DROP USER ''@'localhost'"
    mysql -e "DROP USER ''@'$(hostname)'"
    mysql -e "DROP DATABASE test"
    mysql -e "FLUSH PRIVILEGES"

    printf "\n\n"
    printf "${yellow}testing mysql service..${normal}"
    systemctl status mysql.service

    printf "\n\n"
    printf "${yellow}connect to mysql service..${normal}"
    mysql -u ${mysql_root_user} -p${mysql_root_password} \
        -e "SELECT host, user from mysql.user;"

    printf "\n\n"
    printf "verifying port is open to allow remote access to mysql.."
    nc -vz ${mysql_hostname} ${mysql_port}

popd > /dev/null