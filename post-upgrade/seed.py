from glob import glob
from config import *
from odoo_service import *

models = ['fgmed.id.regulators', 'fgmed.professional.regulators', 'fgmed.profession.list']

for m in models:
    rows = seeder.search_read(m)
    for row in rows:
        found = target.search_read(m, ['name', '=', row['name']])
        if not found:
            print("Adding '{}' to {}".format(row['name'], m))
            target.create(m, **row)
        else:
            print("Skipping {}".format(row['name']))

# import re

#pattern = re.compile(r"Many2one\s*\(['\"](.*?)['\"]")

#for f in glob(fg_modules_path + "/*/models/*.py"):
#    with open(f) as h: content = h.read()
#    matches = pattern.findall(content)
#    if matches: print(matches)

