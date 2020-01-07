password=$(config password)
user=$(config user)

echo "ALTER USER $user WITH PASSWORD '$password';" > /tmp/pg-user-password.sql
cat /tmp/pg-user-password.sql

set -x

su - postgres -l -c "psql -f  /tmp/pg-user-password.sql"
