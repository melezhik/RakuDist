perl -n -e '@f = split; print "curl -d os=debian -d sparky=1 http://repo.westus.cloudapp.azure.com/rakudist/api/run/$f[0]\n"' utils/modules.list | sh
