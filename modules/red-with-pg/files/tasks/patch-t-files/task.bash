set -e

dir=$(config dir)

cd $dir

perl -i -p -e 'my $id = 1; s/%\*ENV<RED_DATABASE>/q|"host=localhost dbname=red| . $i++ . q|"|/ge' t/*.t

grep  'host=localhost dbname=red' t/*.t

