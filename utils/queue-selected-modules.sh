export shai=$1
perl -n -e '@f = split; print "curl -d os=debian -d rakudo_version=$ENV{shai} http://repo.westus.cloudapp.azure.com/rakudist/api/run/$f[0]\n"' utils/selected.list | sh
