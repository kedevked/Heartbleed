#!/bin/bash

if [[ ! -f "/etc/ssl/private/server.key"]] -a [[! -f "/etc/ssl/certs/server.crt" ]]; then

echo " Warning: some files are missing"

else

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")
source $SCRIPT_PATH/front-end/certificate-scripts/default_config.sh

# Generate PKI infrastructure in /etc/apache2/certificate_authority
$SCRIPT_PATH/front-end/certificate-scripts/generate_pki.sh

# Enable SSL in Apache
sudo a2enmod ssl
sudo service apache2 force-reload

cat <<EOF> $APACHE_LOCATION/sites-available/projetcis.conf
<VirtualHost *:80>
  DocumentRoot /var/www/html
  ServerName  $SERVER_CN

  Redirect / https://$SERVER_CN

</VirtualHost>

<VirtualHost *:443>
  DocumentRoot /var/www/html
  ServerName  $SERVER_CN

#  Redirect / https://localhost/test

  ServerSignature Off
#  ErrorLog \${APACHE_LOG_DIR}/error_webmail.log
  LogLevel info
#  CustomLog \${APACHE_LOG_DIR}/access_webmail.log combined

  SSLEngine on
  SSLCertificateFile /etc/ssl/certs/$SERVER_CN.crt
  SSLCertificateKeyFile /etc/ssl/private/$SERVER_CN.key

#  SSLCACertificateFile $CA_LOCATION/certs/$CA_CN.crt

#  SSLCARevocationCheck chain
#  SSLCARevocationFile $CA_LOCATION/crl/$CRL_LIST_NAME

#  SSlVerifyClient require
  SSLOptions +StdEnvVars

</VirtualHost>
EOF

# Force port 443
cat <<EOF> $APACHE_LOCATION/ports.conf
# If you just change the port or add more ports here, you will likely also
# have to change the VirtualHost statement in
# /etc/apache2/sites-enabled/000-default.conf

Listen 80
Listen 443
<IfModule ssl_module>
	Listen 443
</IfModule>

<IfModule mod_gnutls.c>
	Listen 443
</IfModule>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOF

sudo a2dissite 000-default.conf
sudo a2ensite projetcis.conf
sudo service apache2 restart

fi
