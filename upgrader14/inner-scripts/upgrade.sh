cd /OpenUpgrade
git checkout 14.0
echo '#!/usr/bin/env python3.7' > odoo-bin-tmp
awk 'NR > 1' odoo-bin >> odoo-bin-tmp
chmod 777 odoo-bin-tmp
./odoo-bin-tmp -d odoo --stop-after-init -u all
