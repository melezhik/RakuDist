perl -n -e '@f = split; print "echo ; curl -n $f[0]; curl -d sparky=1 http://repo.westus.cloudapp.azure.com/rakudist/api/run/$f[0]\n"' utils/modules.list | sh
