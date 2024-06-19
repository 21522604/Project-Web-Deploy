#!/bin/bash
set -e

echo "Setting default character set to utf8mb4"
mysql --default-character-set=utf8mb4 -u root -h dbinstance.chkyog0u07rz.us-east-1.rds.amazonaws.com -p12345678 clothes-web-shop < /docker-entrypoint-initdb.d/init.sql
