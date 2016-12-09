#!/bin/bash

# Install apache2 

VERSION=$(lsb_release -r)

RELEASE_YEAR=`echo $VERSION |awk -F "." '{ print $1 }'`

if [[ $RELEASEYEAR -gt "14" ]] ; then
echo "install on a new version"
sudo apt install apache2 php mysql-server libapache2-mod-php php-mysql
else
echo "old version"
sudo apt-get install apache2 php5 mysql-server libapache2-mod-php5 php5-mysql
fi
