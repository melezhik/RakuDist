export shai=$1
perl -n -e '@f = split; print "echo -n $f[0] ; curl -s -d os=debian -d rakudo_version=$ENV{shai} http://repo.westus.cloudapp.azure.com/rakudist/api/run/$f[0]; echo\n"' utils/selected.list | sh
