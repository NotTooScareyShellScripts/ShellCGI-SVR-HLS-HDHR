#!/bin/bash
# License MIT
mkdir -v /var/www/html/hls
cd /var/www/html/hls
for i in $(cat /var/www/html/channels.txt);do mkdir -v $(echo $i.cgi|cut -d. -f1,2) ; done
