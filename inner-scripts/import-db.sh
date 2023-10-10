su postgres <<'EOF'
psql -c "CREATE USER root"
psql -c "DROP DATABASE IF EXISTS odoo"
psql -c "CREATE DATABASE odoo"
psql -c "GRANT ALL ON DATABASE odoo TO root"
EOF

psql -d odoo -f /in/dump.sql
