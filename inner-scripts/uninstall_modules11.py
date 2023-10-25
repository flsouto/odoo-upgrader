items = [
    'openeducat_core', 'openeducat_achievement', 'openeducat_activity', 'openeducat_admission',
    'openeducat_alumni', 'openeducat_assignment', 'openeducat_attendance', 'openeducat_classroom',
    'openeducat_erp', 'openeducat_exam', 'openeducat_facility', 'openeducat_fees', 'openeducat_health',
    'openeducat_hostel', 'openeducat_l10n_in', 'openeducat_l10n_in_admission', 'openeducat_library',
    'openeducat_parent', 'openeducat_placement', 'openeducat_scholarship', 'openeducat_timetable',
    'openeducat_transportation', 'association', 'base_kanban_stage', 'base_name_search_improved',
    'base_report_auto_create_qweb', 'datetime_formatter', 'l10n_br', 'l10n_br_base', 'l10n_br_crm',
    'l10n_br_zip', 'l10n_br_zip_correios', 'membership', 'project_timesheet', 'sale_service',
    'website_membership', 'mrp_repair', 'theme_bootswatch','crm_claim','hr_timesheet'
]

for item in items:
    try:
        item_name = item
        self.env['ir.module.module'].search([('name', '=', item_name)]).button_immediate_uninstall()
        print(f'Successfully uninstalled: {item_name}')
    except Exception as e:
        print(f'Error while uninstalling {item_name}: {e}')
