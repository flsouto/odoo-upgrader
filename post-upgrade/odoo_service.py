import xmlrpc.client
from config import *

class OdooService:

    def __init__(self, url, db, username, password):
        self.url = url
        self.db = db
        self.username = username
        self.password = password
        self._uid = None

    def uid(self):
        if not self._uid:
            common = xmlrpc.client.ServerProxy('{}/xmlrpc/2/common'.format(self.url))
            self._uid = common.authenticate(self.db, self.username, self.password, {})
        return self._uid

    def models(self):
        return xmlrpc.client.ServerProxy('{}/xmlrpc/2/object'.format(self.url))

    def __call__(self, *args):
        return self.models().execute_kw(self.db, self.uid(), self.password, *args)

    def search_read(self, model, *conditions, **kwargs):
        return self(model, 'search_read', [conditions], kwargs)

    def write(self, model, id, **data):
        return self(model, 'write', [[id], data])

    def create(self, model, **data):
        return self(model, 'create', [data])


source = OdooService(
    source_url,
    source_db,
    source_username,
    source_password
)

target = OdooService(
    target_url,
    target_db,
    target_username,
    target_password
)

seeder = OdooService(
    seeder_url,
    seeder_db,
    seeder_username,
    seeder_password
)
