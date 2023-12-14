import odoo_service
from sys import argv

odoo = getattr(odoo_service,argv[1])


result = odoo.search_read(argv[2], limit=1)
print(result)
