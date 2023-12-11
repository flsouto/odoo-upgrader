from odoo_service import OdooService
from config import *

odoo9 = OdooService(
    source_url,
    source_db,
    source_username,
    source_password
)

odoo14 = OdooService(
    target_url,
    target_db,
    target_username,
    target_password
)


partners = odoo9.search_read('res.partner',
    ['cnpj_cpf','<>','False'],
    fields = ['cnpj_cpf'],
    limit = 999999
)
print("%d" % len(partners))
exit()
fails=[]

for p in partners:
    print("Updating %d with %s" % (p['id'], p['cnpj_cpf']))
    try:
        result = odoo14.write('res.partner', p['id'], l10n_br_cnpj_cpf = p['cnpj_cpf'])
        print(result)
    except:
        fails.append(p['id'])
        print("Fails: %d" % len(fails))

print(fails)
print("Total fails: %d" % len(fails))

