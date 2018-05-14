#!/bin/sh
### Inicio ####
BK_DB_DIR="/backup/pgsql"

# Executando o VACUUM e DUMP dos bancos
for db in $(su -l postgres -c "psql -l -A -F ';' -t | cut -f 1 -d ';' | egrep -v '(template[01]|pg9)'")
do
  BK_DB_ARQ="$db-`date +%y%m%d`-`date +%H%M`.dump"
  #BK_DB_OLD="$db-`date +%y%m%d -d yesterday `-*.dump"
  su -l postgres -c "pg_dump -F c $db -f $BK_DB_DIR/$BK_DB_ARQ" 2> /tmp/pg_dump92.out
  if [ $? -ne 0 ];then
    mutt -s "Script bkpostgresql92 - erro no PG_DUMP $db" rootalert@sc.senai.br < /tmp/pg_dump92.out
    rm -f /tmp/pg_dump92.out $BK_DB_DIR/$BK_DB_ARQ
  #else
  #  rm -f $BK_DB_DIR/$BK_DB_OLD
  fi
done
