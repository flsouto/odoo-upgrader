from odoo_service import *

def migrate_field(model, field_from, field_to, *, formatter=None):

    rows = source.search_read(model,
        [field_from,'<>','False'],
        fields = [field_from],
        limit = 999999
    )

    fails=[]

    for row in rows:
        value = row[field_from]
        if formatter: value = formatter(value)
        if value is False: continue
        print("Updating %d with %s" % (row['id'], value))
        try:
            result = target.write(model, row['id'], **{field_to: value})
        except Exception as e:
            fails.append(row['id'])
            print("Fails: %d" % len(fails))

    print(fails)
    print("Total fails: %d" % len(fails))


def migrate_many2one(model, field_from, field_to, source_table):
    rows = target.search_read(source_table,fields=['id','name'])
    name2id = {r['name']:r['id'] for r in rows}
    errors = []
    for row in source.search_read(model, fields=['id',field_from]):
        if row[field_from]:
            name = row[field_from][1]
            print("Updating ", row['id'], name, field_to, '=',name2id[name])
            try:
                target.write(model, row['id'], **{field_to:name2id[name]})
            except:
                errors.append(row['id'])

    if errors: print("Errors (%d): " % len(errors), errors)

#migrate_many2one('res.partner','x_consclass', 'professional_regulator', 'fgmed.professional.regulators')

import re
from phone import validate_and_sanitize

migrate_field('res.partner','x_whatsapp','mobile', formatter = validate_and_sanitize)

#migrate_field('res.partner','cnpj_cpf','l10n_br_cnpj_cpf')
#migrate_field('res.partner','x_regprof','professional_id')

#todo add more migrations here....
