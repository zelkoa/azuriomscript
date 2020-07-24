#!/bin/bash

echo  "Bienvenue sur le script d'instaltion NON OFFICIEL de azuriom"

echo "Chargement en cours..."
sleep 2
read -p 'Ce script va suprimer NGINX (il n est pas ecore compatible avec) si vous ne voulez pas suprimer nginx faites CTRL + C sinont appuyer sur entrer' entrer

read -p 'Entrez votre nom de domaine (ou l ip du vps si vous n en avez pas) ' domaine
echo "Votre nom de domaine a été mis sur : $domaine !"

sleep 1

read -p 'Utilisez vous un nom de domaine (exemple : montrucbidule.fr. ATTENTION 5.55.55.55 N EST PAS UN NOM DE DOMAINE)?  (y/n) ' -n 1 dom
sleep 1 
echo "Vous avez choisis $dom"
sleep 1 



sleep 2
apt update

apt -y upgrade

apt -y install software-properties-common curl sudo 

LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
apt-add-repository -y universe
apt remove -y nginx
apt install -y apt-transport-https lsb-release ca-certificates
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list
apt update
apt -y install php7.2 php7.2-cli php7.2-gd php7.2-mysql php7.2-pdo php7.2-mbstring php7.2-tokenizer php7.2-bcmath php7.2-xml php7.2-fpm php7.2-curl php7.2-zip mariadb-server apache2 libapache2-mod-php7.2 tar unzip git

echo "=============================="

echo "PHP installer :)"
echo "=============================="

 sleep 2

if [ $dom = "y" ]
then


		echo "=============================="
        echo "Vous avez un nom de domaine instalation de certbot pour le httpS"
		echo "=============================="

		sleep 2
		add-apt-repository -y ppa:certbot/certbot
		apt update
		apt install certbot
		echo "Certbot installer création du certificat"
		service apache2 stop
		service nginx stop 
		certbot certonly --standalone --agree-tos --no-eff-email -d $domaine
		echo "=============================="

		echo "Certificat ssl crée"
		echo "instalation de azutiom"
		echo "=============================="

		sleep 5
		mkdir /var/www/azuriom
		cd /var/www/azuriom
		wget https://azuriom.com/storage/AzuriomInstaller.zip
		unzip AzuriomInstaller.zip
		rm -rf AzuriomInstaller.zip
		
		
echo "<VirtualHost *:80>" >> /etc/apache2/sites-enabled/azurium.conf
echo "  ServerName" $domaine >> /etc/apache2/sites-enabled/azurium.conf
echo "  RewriteEngine On" >> /etc/apache2/sites-enabled/azurium.conf
echo "  RewriteCond %{HTTPS} !=on" >> /etc/apache2/sites-enabled/azurium.conf
echo "  RewriteRule ^/?(.*) https://%{SERVER_NAME}/$1 [R,L] " >> /etc/apache2/sites-enabled/azurium.conf
echo "</VirtualHost>" >> /etc/apache2/sites-enabled/azurium.conf
echo "<VirtualHost *:443>" >> /etc/apache2/sites-enabled/azurium.conf
echo "  ServerName" $domaine >> /etc/apache2/sites-enabled/azurium.conf
echo "  DocumentRoot "/var/www/azuriom"" >> /etc/apache2/sites-enabled/azurium.conf
echo "  AllowEncodedSlashes On" >> /etc/apache2/sites-enabled/azurium.conf
echo "  php_value upload_max_filesize 100M" >> /etc/apache2/sites-enabled/azurium.conf
echo "  php_value post_max_size 100M" >> /etc/apache2/sites-enabled/azurium.conf
echo "  <Directory "/var/www/azuriom">" >> /etc/apache2/sites-enabled/azurium.conf
echo "    AllowOverride all" >> /etc/apache2/sites-enabled/azurium.conf
echo "  </Directory>" >> /etc/apache2/sites-enabled/azurium.conf
echo "  SSLEngine on" >> /etc/apache2/sites-enabled/azurium.conf
echo "  SSLCertificateFile /etc/letsencrypt/live/"$domaine"/fullchain.pem" >> /etc/apache2/sites-enabled/azurium.conf
echo "  SSLCertificateKeyFile /etc/letsencrypt/live/"$domaine"/privkey.pem" >> /etc/apache2/sites-enabled/azurium.conf
echo "</VirtualHost> " >> /etc/apache2/sites-enabled/azurium.conf

chmod -R 755 /var/www/azuriom && chown -R www-data:www-data /var/www/azuriom
a2enmod rewrite
a2enmod ssl
service apache2 restart

echo "Azuriom installer a 50%"
sleep 5	


echo "Instalation de la base de données"
sleep 2

echo "=============================="
read -p 'Entrez le nom d utilisateur de la base de données souhaiter : ' bdduser
echo "=============================="
read -p 'Entrez le mot de passe de cette utilisateur souhaiter : ' bddpas
echo "=============================="
read -p 'Entrez le nom de la base de données souhaiter : ' bddname
echo "=============================="

mysql -u root -e "CREATE USER '${bdduser}'@'127.0.0.1' IDENTIFIED BY '${bddpas}';"
mysql -u root -e "CREATE DATABASE ${bddname};"
mysql -u root -e "GRANT ALL PRIVILEGES ON ${bddname}.* TO '${bdduser}'@'127.0.0.1' WITH GRANT OPTION;"

echo "=============================="
echo "Azuriom installer pour acceder au site veuillez aller sur ${domaine}/install.php  "
echo "Sur le site suivez les étape voici les parametre a entrer pour la base de données" 
echo "=============================="
echo "TYPE = MySQL"
echo "Adresse = 127.0.0.1"
echo "Port = 3306"
echo "Base de données = ${bddname}"
echo "Utilisateur = ${bdduser}"
echo "Mot de passe = ${bddpas}"


else
		echo "=============================="

        echo "Vous n'avez pas de nom de domaine certbot ne vas pas s installer"
		echo "instalation de azutiom"
		echo "=============================="

		sleep 5
		mkdir /var/www/azuriom
		cd /var/www/azuriom
		wget https://azuriom.com/storage/AzuriomInstaller.zip
		unzip AzuriomInstaller.zip
		rm -rf AzuriomInstaller.zip
		
echo "<VirtualHost *:80>" >> /etc/apache2/sites-enabled/azurium.conf
echo "  ServerName" $domaine >> /etc/apache2/sites-enabled/azurium.conf
echo "  DocumentRoot "/var/www/azuriom"" >> /etc/apache2/sites-enabled/azurium.conf
echo "  AllowEncodedSlashes On" >> /etc/apache2/sites-enabled/azurium.conf
echo "  php_value upload_max_filesize 100M" >> /etc/apache2/sites-enabled/azurium.conf
echo "  php_value post_max_size 100M" >> /etc/apache2/sites-enabled/azurium.conf
echo "  <Directory "/var/www/azuriom">" >> /etc/apache2/sites-enabled/azurium.conf
echo "    AllowOverride all" >> /etc/apache2/sites-enabled/azurium.conf
echo "  </Directory>" >> /etc/apache2/sites-enabled/azurium.conf
echo "</VirtualHost>" >> /etc/apache2/sites-enabled/azurium.conf

chmod -R 755 /var/www/azuriom && chown -R www-data:www-data /var/www/azuriom
a2enmod rewrite
a2enmod ssl
service apache2 restart

echo "Azuriom installer a 50%"
sleep 5	


echo "Instalation de la base de données"
sleep 2

echo "=============================="
read -p 'Entrez le nom d utilisateur de la base de données souhaiter : ' bdduser
echo "=============================="
read -p 'Entrez le mot de passe de cette utilisateur souhaiter : ' -s bddpas
echo "=============================="
read -p 'Entrez le nom de la base de données souhaiter : ' bddname
echo "=============================="

mysql -u root -e "CREATE USER '${bdduser}'@'127.0.0.1' IDENTIFIED BY '${bddpas}';"
mysql -u root -e "CREATE DATABASE ${bddname};"
mysql -u root -e "GRANT ALL PRIVILEGES ON ${bddname}.* TO '${bdduser}'@'127.0.0.1' WITH GRANT OPTION;"

echo "=============================="
echo "Azuriom installer pour acceder au site veuillez aller sur ${domaine}/install.php  "
echo "Sur le site suivez les étape voici les parametre a entrer pour la base de données" 
echo "=============================="
echo "TYPE = MySQL"
echo "Adresse = 127.0.0.1"
echo "Port = 3306"
echo "Base de données = ${bddname}"
echo "Utilisateur = ${bdduser}"
echo "Mot de passe = ${bddpas}"

echo "=============================="

fi
