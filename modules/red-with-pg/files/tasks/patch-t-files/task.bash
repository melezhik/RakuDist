set -e

dir=$(config dir)

cd $dir

perl -i -p -e 'my $id = 1; s/database "SQLite".*$/q{database "Pg", :dbname<red} . $i++ . q{>;}/ge' t/*.t

grep  'database "Pg"' t/*.t

