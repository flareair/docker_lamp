#!/bin/sh

sqlname=example`date +"%y%m%d-%H%M.sql.zip"`
filename=example`date +"%y%m%d-%H%M.zip"`


docker exec -it example mysqldump -u root site | zip > backup/${sqlname}

zip backup/${filename} site/*

echo 'Backups created '${filename} ${sqlname}
