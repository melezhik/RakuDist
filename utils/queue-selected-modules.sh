export shai=$1
perl -n -e '@f = split; print "echo -n $f[0] ; curl -s -d os=debian -d rakudo_version=$ENV{shai} -d thing=$f[0] http://rakudist.raku.org/queue; echo\n"' utils/selected.list | sh
