#!/bin/sh

set -e
mkdir -p tmp/backups
ssh basil@easypeasy 'pg_dump easypeasy_production | gzip > backup_`date +%Y.%m.%d`.sql.gz'
mkdir -p ./tmp/backups
scp basil@easypeasy:backup_`date +%Y.%m.%d`.sql.gz ./tmp/backups/
gunzip -f ./tmp/backups/backup_`date +%Y.%m.%d`.sql.gz
dropdb easypeasy_development
createdb easypeasy_development
psql easypeasy_development < ./tmp/backups/backup_`date +%Y.%m.%d`.sql
dropdb easypeasy_test
createdb easypeasy_test
psql easypeasy_test < ./tmp/backups/backup_`date +%Y.%m.%d`.sql
