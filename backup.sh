#!/bin/sh

container_name=remontuaz

sqlname=${container_name}`date +"%y%m%d-%H%M.sql"`
filename=${container_name}`date +"%y%m%d-%H%M.zip"`


docker exec -it ${container_name} mysqldump -u root site > backup/${sqlname}

zip -r backup/${filename} site/*

echo 'Backups created '${filename} ${sqlname}
