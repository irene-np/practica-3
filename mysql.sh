#!/bin/bash
# Actualizar PC
apt-get update

# Instalamos defconf-utils -y
apt-get install debconf-utils -y

# Configuramos la contraseña mysql
DB_ROOT_PASSWD=root
debconf-set-selections <<< "mysql-sever mysql-server/root_password password $DB_ROOT_PASSWD"
debconf-set-selections <<< "mysql-sever mysql-server/root_password_again password $DB_ROOT_PASSWD"
 
# Instalar mysql
apt-get install mysql-server -y

# Instalamos git
apt-get install git -y

# Instalamos la aplicacion
cd /home/ubuntu
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git
chown www-data:www-data * -R

# Configuramos la aplicacion web
DB_NAME=lamp_db
DB_USER=lamp_user
DB_PASSWD=lamp_user
mysql -u root -p$DB_ROOT_PASSWD <<< "DROP DATABASE IF EXISTS $DB_NAME;"
mysql -u root -p$DB_ROOT_PASSWD <<< "CREATE DATABASE $DB_NAME;"
mysql -u root -p$DB_ROOT_PASSWD <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@'%' IDENTIFIED BY '$DB_PASSWD';"
mysql -u root -p$DB_ROOT_PASSWD <<< "FLUSH PRIVILEGES"

mysql -u root -p$DB_ROOT_PASSWD < /home/ubuntu/iaw-practica-lamp/db/database.sql