# practica-3
Nos creamos dos intancias:
Una que tendra una capa  front-end - para instalar apache http server.
otra que tendra una capa  back-end - para instalar mysql.
En las 2 hay que abrir los puertos ssh, http y https.

# URL del repositorio
https://github.com/irene-np/practica-3.git


Nos creamos dos script, una para cada maquina. Asi no tenemos que poner los pasos uno a uno. Con el script se ejecuta todos los pasos seguidos.

script de Apache http server

```sh

#!/bin/bash
# Actualizar PC
apt-get update

#Instalamos adminer
cd /var/www/html
mkdir adminer
cd adminer
wget https://github.com/vrana/adminer/releases/download/v4.7.3/adminer-4.7.3-mysql.php
mv adminer-4.7.3-mysql.php index.php

# 2. Instalar apache2
sudo apt-get install apache2 -y

# Arrancar el apache2
systemctl start apache2

# Instalar paquete
apt-get install php libapache2-mod-php php-mysql -y

# Instalamos git
apt-get install git -y

# Instalamos la aplicacion
cd /var/www/html
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git
chown www-data:www-data * -R

```
script mysql

```sh

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
```

Nos vamos a la instacia del mysql y hacemos lo siguiente:

## Conectar instacia
```
ssh -i "ruta de la key" ubuntu@ip
```
## Configuración del mysql
```
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
```

Nos vamos a bind-address y cambiamos 127.0.0.1.
Si tenemos una interfaz, ponemos nuestra ip si tiene mas de una, se pone 0.0.0.0

Reiniciamos el servicio de Mysql
```
sudo /etc/init.d/mysql restart
```
## Privilegios a los usuarios
Damos privilegios al usuario de MySQL
```
mysql -u root -p  
mysql> grant all privileges on DATABASE.* to USERNAME@IP-SERVIDOR-HTTP identified by 'PASSWORD';
mysql> flush privileges;
mysql> exit;
```
- database = lamp_db
- username@ip-servidor -http  = lamp_user@52.90.89.150
- password = lamp_user

Para que un usuario se pueda conectar a cualquier dirección IP utilizamos %

```
mysql -u root -p  
mysql> grant all privileges on DATABASE.* to USERNAME@'%' identified by 'PASSWORD';
mysql> flush privileges;
mysql> exit;
```
## Comprobamos la lista de usuarios de MySQL
```
SELECT user,host FROM mysql.user;
```
Consultar los permisos, de cualquier usuario.

```
SHOW GRANTS FOR (usuario);
```

Desde la máquina donde tenemos apache instalado, ponemos lo siguiente para comprobar que podemos conectarnos con MySQL

```
mysql -u USERNAME -p -h IP-SERVIDOR-MYSQL
```
O 

```
telnet IP-SERVIDOR-MYSQL 3306
```