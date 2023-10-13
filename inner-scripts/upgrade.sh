cd /OpenUpgrade
git checkout $UPGRADER_VERSION.0

if [[ $UPGRADER_VERSION -gt 10 ]]; then
    PYTHON_VERSION="3.7"
else
    PYTHON_VERSION="2.7"
fi

echo "#!/usr/bin/env python$PYTHON_VERSION" > odoo-bin-tmp
awk 'NR > 1' odoo-bin >> odoo-bin-tmp
chmod 777 odoo-bin-tmp
./odoo-bin-tmp -d odoo --stop-after-init -u all
