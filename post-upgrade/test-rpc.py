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

odoo14.write('res.partner',101362,name='José Lindomar Costa e Silva')
result = odoo14.search_read('res.partner',['id','=',101362],limit=1)
print(result)
exit()


partners = odoo9.search_read('res.partner',
    ['cnpj_cpf','<>','False'],
    fields = ['cnpj_cpf'],
    limit = 10
)

for p in partners:
    print('{} - {}'.format(p['id'], p['cnpj_cpf']))


