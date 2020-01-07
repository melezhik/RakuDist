set -e

dir=$(config dir)

cd $dir

perl -i -p -e 's/database "SQLite"/database "Pg"/g' t/*.t
