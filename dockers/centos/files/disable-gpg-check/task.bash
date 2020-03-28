set -x
set -e
find /etc/yum.repos.d/ -name *.repo -exec perl -i -p -e 's{gpgcheck=1}{gpgcheck=0}g' {} \;
find /etc/yum.repos.d/ -name *.repo -exec cat {} \;
