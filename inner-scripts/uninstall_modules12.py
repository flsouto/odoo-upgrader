items = [
    'web_diagram','website_forum_doc','account_asset_management',
    'stock',
    'stock_account',
    'purchase_stock',
    'sale_stock',
    'website_sale_stock'
]

for item in items:
    try:
        item_name = item
        self.env['ir.module.module'].search([('name', '=', item_name)]).button_immediate_uninstall()
        print(f'Successfully uninstalled: {item_name}')
    except Exception as e:
        print(f'Error while uninstalling {item_name}: {e}')
