#!/bin/bash

# Check if certificate is still valid
# xpires=$(openssl x509 -in lighttpd.pem  -text -noout | awk '/Not After/ { print $4 $5 $7 }')
# today=$(date +'%b%d%Y')
# if today > xpires then remove certifcates
# better put this in a daemon and control once a day

# Create Selfsigned certificate (may better to create a new one at every powercycle ?
if [ ! -f /etc/lighttpd/certs/lighttpd.pem ]; then
        /usr/bin/test ! -d /etc/lighttpd/certs && /usr/bin/mkdir -p /etc/lighttpd/certs 
        echo "create self-signed certficate"
        openssl req -new -x509 -days 365 -nodes -out /etc/lighttpd/certs/lighttpd.pem -keyout /etc/lighttpd/certs/lighttpd.key -subj '/C=DE/O=DEMO/CN=*'
	cat /etc/lighttpd/certs/lighttpd.key >> /etc/lighttpd/certs/lighttpd.pem
fi

# restart the php server
[ -f /run/php-fpm/php-fpm.pid ] && kill $(cat /run/php-fpm/php-fpm.pid) && sleep 5
echo "starting php server"
/usr/sbin/php-fpm

chmod a+w /dev/pts/0
echo "start webserver"
exec lighttpd -D -f /etc/lighttpd/lighttpd.conf
