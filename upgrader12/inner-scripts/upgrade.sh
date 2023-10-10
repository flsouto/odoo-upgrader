echo '#!/usr/bin/env python3.7' > /OpenUpgrade/odoo-bin-tmp
awk 'NR > 1' /OpenUpgrade/odoo-bin >> /OpenUpgrade/odoo-bin-tmp
#todo run odoo-bin-tmp
