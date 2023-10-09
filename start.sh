docker run -v $PWD/OpenUpgrade:/openupgrade \
    -v $PWD/in:/in \
    -v $PWD/out:/out \
    -td --name openupgrade-env \
    flsouto/openupgrade-env:v1.0
