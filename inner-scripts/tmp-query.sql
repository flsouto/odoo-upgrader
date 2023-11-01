
-- SELECT imm.name FROM ir_model_constraint imc
--    LEFT JOIN ir_module_module imm ON imm.id = imc.module
--    WHERE imm.id IS NULL OR imm.state <> 'installed'
--;

DELETE FROM ir_model_constraint WHERE module IN(
    SELECT id FROM ir_module_module WHERE state <> 'installed'
)
