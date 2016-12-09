## create an autosigned certificate of the server and copy the files on the server
sudo openssl req -new -x509 -days 365 -nodes -out /etc/ssl/certs/server.crt -keyout /etc/ssl/private/server.key

## set the https configuration

./configure_https_apache.sh
