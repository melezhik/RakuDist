
podman ps

podman stop -t 1 debian-rakudist
podman stop -t 1 alpine-rakudist
podman stop -t 1 centos-rakudist
podman stop -t 1 ubuntu-rakudist

set -x
set -e

podman run -d -t --rm --name debian-rakudist 5971ee6076a0
podman run -d -t --rm --name alpine-rakudist a24bb4013296
podman run -d -t --rm --name centos-rakudist 470671670cac
podman run -d -t --rm --name ubuntu-rakudist 1d622ef86b13


podman ps

exit

for i in debian centos alpine ubuntu; do

  echo "[bootstrap $i]"
  cd ~/projects/RakuDist/dockers/$i
  sparrowdo --bootstrap --docker="$i-rakudist" --no_sudo
  
done


