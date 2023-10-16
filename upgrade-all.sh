FROM=$1
TO=$2

for i in $(seq $FROM $TO)
do
    ./make-upgrader.sh $i
    cd upgrader$i
    docker-compose up -d
    sleep 10
    docker-compose exec main bash "/scripts/import-db.sh"
    docker-compose exec main bash "/scripts/upgrade.sh"
    docker-compose exec main bash "/scripts/export.sh"
    docker-compose down
    cd ..
    cp out/dump.sql in/dump.sql
done
