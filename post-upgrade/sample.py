import odoo_service
from sys import argv

odoo = getattr(odoo_service,argv[1])


if len(argv) < 4:
    result = odoo.search_read(argv[2], limit=10)
else:
    result = [row[argv[3]] for row in odoo.search_read(argv[2], limit=99)]

print(result)
