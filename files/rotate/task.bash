
podman ps

podman stop -t 1 debian-rakudist
podman stop -t 1 alpine-rakudist
podman stop -t 1 centos-rakudist
podman stop -t 1 ubuntu-rakudist

set -x
set -e

podman run -d -t --rm --name debian-rakudist 25b4fc242478
podman run -d -t --rm --name alpine-rakudist 2eefe624417e
podman run -d -t --rm --name centos-rakudist 470671670cac
podman run -d -t --rm --name ubuntu-rakudist db2e908ef01e


podman ps

for i in debian centos alpine ubuntu; do

  echo "[bootstrap $i]"
  cd ~/projects/RakuDist/dockers/$i
  #sparrowdo --bootstrap --docker="$i-rakudist" --no_sudo
  
done


