from odoo_service import *

def migrate_field(model, field_from, field_to):

    rows = source.search_read(model,
        [field_from,'<>','False'],
        fields = [field_from],
        limit = 999999
    )

    fails=[]

    for row in rows:
        print("Updating %d with %s" % (row['id'], row[field_from]))
        try:
            result = target.write(model, row['id'], **{field_to: row[field_from]})
            print(result)
        except:
            fails.append(row['id'])
            print("Fails: %d" % len(fails))

    print(fails)
    print("Total fails: %d" % len(fails))


migrate_field('res.partner','cnpj_cpf','l10n_br_cnpj_cpf')
#todo add more migrations here....
