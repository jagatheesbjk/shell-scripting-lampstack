#Author: Jagathees Kumar.B
#Version: 1.0
#Automation: LAMP STACK
COLUMNS=$(tput cols)
get_date_time()
{
echo $(date '+%d-%m-%Y %r')
}
prRed(){
  echo -e "\033[91m$1 \033[00m"
}
prGreen(){
  echo -e "\033[92m$1 \033[00m"
}
prYellow(){
  echo -e "\033[93m$1 \033[00m"
}
prPurple(){
  echo -e "\033[95m$1 \033[00m"
}
prCyan(){
  echo -e "\033[96m$1 \033[00m"
}
prHeader()
{
for each in $(seq 1 $COLUMNS)
do
echo -n $1
done
}
prtxtCentre()
{
title=$1
printf "%*s\n" $(((${#title}+$COLUMNS)/2)) "$title"
}

package_ver_check()
{
which apt 1>/dev/null 2>/dev/null
if [[ $? -eq 0 ]]
then
prHeader "="
prtxtCentre "Use APT Base Package Type"
prHeader "="
else
prHeader "="
prtxtCentre "Use YUM Base Package Type"
prHeader "="
fi
}
package_upupg()
{
package_ver_check
if [[ -n $(command -v apt) ]]
then
prGreen "Now Doing Package Update & Package Upgrade"
sudo apt update 2&>1 && sudo apt upgrade -y 1>/dev/null 2>/dev/null
prGreen "Now Package Update & Upgrade Completed........"
else
prRed "Check with alternate package type if that fail check with apt repo link"
fi
if [[ -n $(command -v yum) ]]
then
prGreen "Now Doing Package Update & Package Upgrade"
sudo yum update 2&>1 && sudo yum upgrade -y 1>/dev/null 2>/dev/null
prGreen "Now Package Update & Upgrade Completed........"
else
prRed "Check with alternate package type if that fail check with yum repo link"
fi
}
apache_package()
{
  prHeader "="
  prtxtCentre "Apache Installation"
  prHeader "="
  prGreen "Apache Package is Installing........."
  sudo apt install apache2 -y 1>/dev/null 2>/dev/null || sudo yum install httpd -y 2&>1 && sudo systemctl start httpd 1>/dev/null 2>/dev/null
  prGreen "Apache Package is Installed"
}
phpv_package()
{
  prHeader "="
  prtxtCentre "PHP Installation"
  prHeader "="
command -v apt
if [[ $? -eq 0 ]]
then
prGreen "Need to add common Repository for PHP APT package type now adding......"
sudo apt install -y software-properties-common 1>/dev/null 2>/dev/null
sudo add-apt-repository ppa:ondrej/php -y 1>/dev/null 2>/dev/null
if [[ $? -eq 0 ]]
then
prGreen "Now PHP Repo added"
else
prRed "Adding PHP Repo Problem check it with that."
fi
read -p "Enter PHP Version need to install: " phpv
prGreen "PHP Installing......"
sudo apt install -y php${phpv} php${phpv}-cli php${phpv}-common php${phpv}-json php${phpv}-opcache php${phpv}-mysql php${phpv}-mbstring php${phpv}-mcrypt php${phpv}-zip 1>/dev/null 2>/dev/null
sudo apt install -y php${phpv}-fpm php${phpv}-xml 1>/dev/null 2>/dev/null
if [[ $? -eq 0 ]]
then prGreen "PHP Installed"
fi
else
sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm 1>/dev/null 2>/dev/null
sudo yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm 1>/dev/null 2>/dev/null
sudo yum -y install yum-utils 1>/dev/null 2>/dev/null
prHeader "="
prtxtCentre "Enter PHP Version: "
prCyan "1: 7.4"
prCyan "2. 8.0"
prCyan "3. 8.1"
prHeader "="
read -p "Enter PHP Version to install: " phpv
case $phpv in
    7.4)
        sudo yum-config-manager --disable remi-php* 1>/dev/null 2>/dev/null
        sudo yum-config-manager --enable remi-php74 1>/dev/null 2>/dev/null
        sudo yum -y install php php-{cli,fpm,mysqlnd,zip,devel,gd,mbstring,curl,xml,pear,bcmath,json,opcache,redis,memcache} 1>/dev/null 2>/dev/null
        ;;
    8.0)
        sudo yum-config-manager --disable remi-php* 1>/dev/null 2>/dev/null
        sudo yum-config-manager --enable remi-php80 1>/dev/null 2>/dev/null
        sudo yum -y install php php-{cli,fpm,mysqlnd,zip,devel,gd,mbstring,curl,xml,pear,bcmath,json,opcache,redis,memcache} 1>/dev/null 2>/dev/null
        ;;
    8.1)
        sudo yum-config-manager --disable remi-php* 1>/dev/null 2>/dev/null
        sudo yum-config-manager --enable remi-php81 1>/dev/null 2>/dev/null
        sudo yum -y install php php-{cli,fpm,mysqlnd,zip,devel,gd,mbstring,curl,xml,pear,bcmath,json,opcache,redis,memcache} 1>/dev/null 2>/dev/null
        ;;
    *)
        prRed "You Enter Wrong Information"
        ;;
esac
if [[ $? -eq 0 ]]
then
prGreen "PHP Installed."
else
prRed  "Something went wrong check with that"
fi
fi
}
mysql_package()
{
  prHeader "="
  prtxtCentre "MYSQL Installation"
  prHeader "="
read -sp "Enter Database Password: " dbpass
command -v apt
if [[ $? -eq 0 ]]
then
prGreen "\nDatabase is Installing........"
sudo apt install -y mysql-server 1>/dev/null 2>/dev/null
if [[ $? -eq 0 ]]
then
prGreen "Database is installed."
fi
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${dbpass}'; flush privileges;"
exit
else
prGreen "\nDatabase is installing........."
curl -sSLO https://dev.mysql.com/get/mysql80-community-release-el7-7.noarch.rpm 1>/dev/null 2>/dev/null
prGreen "`sudo rpm -ivh mysql80-community-release-el7-7.noarch.rpm`" 1>/dev/null 2>/dev/null
#prGreen "`sudo yum install mysql-server`"
sudo yum-config-manager --enable mysql80-community 1>/dev/null 2>/dev/null
sudo yum install mysql-community-server -y 1>/dev/null 2>/dev/null
sudo systemctl start mysqld 1>/dev/null 2>/dev/null
sudo systemctl status mysqld 1>/dev/null 2>/dev/null
if [[ $? -eq 0 ]]
then
prGreen "Database is installed."
else
prRed "Check Database Installation & Startup"
fi
dbtmppas="`sudo grep 'temporary password' /var/log/mysqld.log | sed 's/.*root@localhost: //'`"
sudo mysql -uroot --password=$dbtmppas --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${dbpass}'; flush privileges;"
fi
exit
}
package_ver_check
prGreen "Checking APT or YUM based Package Version........"
package_upupg
apache_package
phpv_package
mysql_package