FROM=$1
TO=$2

for i in $(seq $FROM $TO)
do
    ./make-upgrader.sh $i
    cd upgrader$i
    docker-compose up -d
    if [[ ! -z "$SKIP_FILESTORE" ]]; then
        exec_params="-e SKIP_FILESTORE=1"
    fi
    sleep 10
    docker-compose exec $exec_params main bash "/scripts/import-db.sh"
    docker-compose exec $exec_params main bash "/scripts/upgrade.sh"
    docker-compose exec $exec_params main bash "/scripts/export.sh"
    docker-compose down
    cd ..
    rm in/data/filestore/odoo/checklist -Rf
done
