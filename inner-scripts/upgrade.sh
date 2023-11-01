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

run_query="sudo -u postgres psql -d odoo -c"

if [[ $UPGRADER_VERSION == 14 ]]; then

    cd /odoo

    echo "#!/usr/bin/env python3.7" > odoo-bin-tmp
    awk 'NR > 1' odoo-bin >> odoo-bin-tmp
    chmod 777 odoo-bin-tmp

    $run_query "UPDATE res_partner SET lang='en_US'"

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
        $run_query "DELETE FROM ir_module_module WHERE name = 'theme_bootswatch';"
        $run_query "DELETE FROM ir_model_data WHERE module = 'theme_bootswatch';"
        $run_query "DELETE FROM ir_model_data WHERE name = 'module_theme_bootswatch';"

        # altera o formato de endereço
        address_format=' %(street)s, %(street2)s\n%(zip)s - %(city)s - %(state_code)s\n%(country_name)s'
        $run_query "UPDATE res_country SET address_format = E'$address_format' WHERE name LIKE 'Brazil';"
    fi

    if [[ $UPGRADER_VERSION == 12 ]]; then
        # desativa views problemáticas
        $run_query "UPDATE ir_ui_view SET active = false WHERE name='account assets';"
    fi

    if [[ $UPGRADER_VERSION == 13 ]]; then
        # altera language
        $run_query "UPDATE res_partner SET lang='en_US' WHERE id IN(SELECT partner_id FROM res_users)"
        $run_query "UPDATE website SET default_lang_code = 'pt_BR', default_lang_id = 1"
        $run_query "UPDATE website_lang_rel SET lang_id = 1 WHERE website_id = 1"
        $run_query "UPDATE res_lang SET active = false WHERE id = 2"

        # deleta constraint
        $run_query "DELETE FROM ir_model_constraint WHERE module IN(\
            SELECT id FROM ir_module_module WHERE state <> 'installed'\
        )"
    fi


    ./odoo-bin-tmp -d odoo --stop-after-init -u all $data_dir_param

    # remove demais módulos problemáticos via script
    if [[ $UPGRADER_VERSION == 11 ]]; then
        cat /scripts/uninstall_modules11.py | ./odoo-bin-tmp shell -d odoo
    fi

    if [[ $UPGRADER_VERSION == 12 ]]; then
        cat /scripts/uninstall_modules12.py | ./odoo-bin-tmp shell -d odoo
    fi

    if [[ $UPGRADER_VERSION == 13 ]]; then
        cat /scripts/uninstall_modules13.py | ./odoo-bin-tmp shell -d odoo
    fi

fi
