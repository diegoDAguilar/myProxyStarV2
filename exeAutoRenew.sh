#!/bin/bash

if [ "$#" -ne 4 ]; then
    echo "Illegal number of parameters"
    exit 1
fi
domainName=$1 # e.g. bye.com
getDeadLineD=$2 # "day month" format, e.g. 19 06
getDeadLineM=$3 # "day month" format, e.g. 19 06
cronTaskID=$4 # integer

#Gets the uri using cronTaskID
file="/root/starCerts/links/link$cronTaskID"
uri=$(cat "$file")
#Removes old certificate
rm "/root/starCerts/$uri/certificate.pem"
cd /root/certbot/certbot
if date "+%d %m" | grep -q "$getDeadLineD $getDeadLineM"; then
       echo "Lifetime expires"
       crontab -u root -l | grep -v "$domainName $getDeadLineD $getDeadLineM $crontaskID" | crontab -u root -
else
        echo "Renews cert"
        a=" --csr ../../starCerts/$uri/csr$cronTaskID --agree-tos -m tutatis@gmail.com --renew-by-default -d $domainName"
        b=" --server http://172.17.0.4:4000/directory --webroot -w /var/www/$domainName/html"
        c=" --fullchain-path ../../starCerts/$uri/certificate.pem"
#Changes the content of STARValidityCertbot
validity=$(cat "../../starCerts/$uri/validity$cronTaskID")
echo "Validity is : $validity"
if [ -f /root/STARValidityCertbot ]; then
        rm -rf /root/STARValidityCertbot
fi
echo $validity > /root/STARValidityCertbot
#Executes Certbot with the old csr
python main.py certonly $a $b $c

#Removes tmpFiles
cd /root/
rm certId
rm ObtainedCERT.pem
rm STARValidityCertbot
fi
