set -x
docker ps
docker stop -t 1 debian-rakudist
docker stop -t 1 alpine-rakudist
docker stop -t 1 centos-rakudist
docker run -d -t --rm --name debian-rakudist 1b41711bb6c8
docker run -d -t --rm --name alpine-rakudist c70676a7b62b
docker run -d -t --rm --name centos-rakudist 0bfb68601d70
docker ps

cd ~/projects/RakuDist/dockers/debian
sparrowdo --bootstrap --docker=debian-rakudist --no_sudo

cd ~/projects/RakuDist/dockers/centos
sparrowdo --bootstrap --docker=centos-rakudist --no_sudo

cd ~/projects/RakuDist/dockers/alpine
sparrowdo --bootstrap --docker=alpine-rakudist --no_sudo

