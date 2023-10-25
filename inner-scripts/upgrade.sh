cd /OpenUpgrade
git restore .
git checkout $UPGRADER_VERSION.0

if [[ $UPGRADER_VERSION -gt 10 ]]; then
    PYTHON_VERSION="3.7"
else
    PYTHON_VERSION="2.7"
fi

data_dir_params=""
if [[ -z "$SKIP_FILESTORE" ]]; then
    data_dir_param="--data-dir=/in/data"
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
	--load=base,web,openupgrade_framework \
	$data_dir_param

else

    echo "#!/usr/bin/env python$PYTHON_VERSION" > odoo-bin-tmp
    awk 'NR > 1' odoo-bin >> odoo-bin-tmp
    chmod 777 odoo-bin-tmp

    if [[ $UPGRADER_VERSION == 11 ]]; then

        # remove o tema do bootswatch para permitir que a migração do 10 para o 11 seja concluída
        sudo -u postgres psql -d odoo -c "DELETE FROM ir_module_module WHERE name = 'theme_bootswatch';"
        sudo -u postgres psql -d odoo -c "DELETE FROM ir_model_data WHERE module = 'theme_bootswatch';"
        sudo -u postgres psql -d odoo -c "DELETE FROM ir_model_data WHERE name = 'module_theme_bootswatch';"

        # altera o formato de endereço
        address_format=' %(street)s, %(street2)s\n%(zip)s - %(city)s - %(state_code)s\n%(country_name)s'
        sudo -u postgres psql -d odoo \
            -c "UPDATE res_country SET address_format = E'$address_format' WHERE name LIKE 'Brazil';"
    fi

    ./odoo-bin-tmp -d odoo --stop-after-init -u all $data_dir_param

    # remove demais módulos problemáticos via script
    if [[ $UPGRADER_VERSION == 11 ]]; then
        cat /scripts/uninstall_modules.py | ./odoo-bin-tmp shell -d odoo
    fi


fi
