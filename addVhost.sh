#!/bin/bash


##
# Creation de Vhosts apache
# usage :
#		./addvhost vhost_name [use_ssl]
#
##

# Définit le dossier racine des app apache
ROOT_DIR="/home/luke/www/"


if [ $# == 0 ]
then 

	echo "to few arguments to process. Operation Failed"
	exit -1

else

	# Copier le template-symfony vers /etc/apache2/sites-available avec le nom vhost_name.conf
	cp ./template-symfony /etc/apache2/sites-available/$1.conf
	
	# Créer le dossier dans le dossier /home/luke/www/
	mkdir -p $ROOT_DIR$1 $ROOT_DIR$1/web
	
	# remplacer template par vhost_name dans le fichier de conf
	sed -i 's/template/'$1'/g' /etc/apache2/sites-available/$1.conf
	
	# ajouter le fichier de conf à la liste des sites actifs
	a2ensite $1.conf
	
	# mettre à jour le fichier hosts
	echo "31.10.1.157 $1.wrk www.$1.wrk" >> /etc/hosts
	
	# vérif de l'exec globale
	echo "<?php phpinfo();" >> $ROOT_DIR$1/web/app.php
	
	# relancer apache
	service apache2 reload

fi
