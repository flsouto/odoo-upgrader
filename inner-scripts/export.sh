pg_dump -d odoo > /out/dump.sql
rm /out/data -Rf
cp /tmp/upgraded-data /out/data -R
