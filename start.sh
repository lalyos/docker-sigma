#!/bin/bash

echo ${TITLE:=Welcome} > /var/www/html/index.html

nginx -g "daemon off;"