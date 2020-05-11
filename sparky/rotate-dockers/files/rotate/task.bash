
docker ps

docker stop -t 1 debian-rakudist
docker stop -t 1 alpine-rakudist
docker stop -t 1 centos-rakudist
docker stop -t 1 ubuntu-rakudist

set -x
set -e

docker run -d -t --rm --name debian-rakudist 1b41711bb6c8
docker run -d -t --rm --name alpine-rakudist a187dde48cd2
docker run -d -t --rm --name centos-rakudist 470671670cac
docker run -d -t --rm --name ubuntu-rakudist 1d622ef86b13



docker ps

for i in debian centos alpine ubuntu; do

  echo "[bootstrap $i]"
  cd ~/projects/RakuDist/dockers/$i
  sparrowdo --bootstrap --docker="$i-rakudist" --no_sudo --repo=http://repo.westus.cloudapp.azure.com
  
done


