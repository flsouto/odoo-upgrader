
import xmlrpc.client

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
