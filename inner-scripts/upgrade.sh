cd /OpenUpgrade
git checkout --
git checkout $UPGRADER_VERSION.0

if [[ $UPGRADER_VERSION -gt 10 ]]; then
    PYTHON_VERSION="3.7"
else
    PYTHON_VERSION="2.7"
fi

if [[ $UPGRADER_VERSION == 14 ]]; then

    cd /odoo

    echo "#!/usr/bin/env python3.7" > odoo-bin-tmp
    awk 'NR > 1' odoo-bin >> odoo-bin-tmp
    chmod 777 odoo-bin-tmp

    ./odoo-bin-tmp -d odoo \
	--addons-path=/odoo/addons,/OpenUpgrade \
	--upgrade-path=/OpenUpgrade/openupgrade_scripts/scripts \
	--update all --stop-after-init \
	--load=base,web,openupgrade_framework --data-dir=/in/data

else

    cp /in/data /tmp/upgraded-data -R
    echo "#!/usr/bin/env python$PYTHON_VERSION" > odoo-bin-tmp
    awk 'NR > 1' odoo-bin >> odoo-bin-tmp
    chmod 777 odoo-bin-tmp
    ./odoo-bin-tmp -d odoo --stop-after-init -u all --data-dir=/tmp/upgraded-data

fi
