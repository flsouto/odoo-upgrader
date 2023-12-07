cd /OpenUpgrade
git restore .
git checkout $UPGRADER_VERSION.0

if [[ $UPGRADER_VERSION -gt 10 ]]; then
    PYTHON_VERSION="3.7"
else
    PYTHON_VERSION="2.7"
fi

if [[ -z "$SKIP_FILESTORE" ]]; then
    data_dir_param="--data-dir=/in/data"
fi

if [[ $UPGRADER_VERSION == 14 ]]; then

    cd /odoo

    echo "#!/usr/bin/env python3.7" > odoo-bin-tmp
    awk 'NR > 1' odoo-bin >> odoo-bin-tmp
    chmod 777 odoo-bin-tmp

    ./odoo-bin-tmp -d odoo --data-dir=/in/data --logfile /in/odoo-14.log

else

    echo "#!/usr/bin/env python$PYTHON_VERSION" > odoo-bin-tmp
    awk 'NR > 1' odoo-bin >> odoo-bin-tmp
    chmod 777 odoo-bin-tmp
    ./odoo-bin-tmp -d odoo --data-dir=/in/data

fi
