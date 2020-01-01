#! /usr/bin/env sh

# Find out the target OS
if [ -s /etc/os-release ]; then
  # freedesktop.org and systemd
  . /etc/os-release
  OS=$NAME
  VER=$VERSION_ID
elif lsb_release -h >/dev/null 2>&1; then
  # linuxbase.org
  OS=$(lsb_release -si)
  VER=$(lsb_release -sr)
elif [ -s /etc/lsb-release ]; then
  # For some versions of Debian/Ubuntu without lsb_release command
  . /etc/lsb-release
  OS=$DISTRIB_ID
  VER=$DISTRIB_RELEASE
elif [ -s /etc/debian_version ]; then
  # Older Debian/Ubuntu/etc.
  OS=Debian
  VER=$(cat /etc/debian_version)
elif [ -s /etc/SuSe-release ]; then
  # Older SuSE/etc.
  printf "TODO\n"
elif [ -s /etc/redhat-release ]; then
  # Older Red Hat, CentOS, etc.
  OS=$(cat /etc/redhat-release| head -n 1)
else
  RELEASE_INFO=$(cat /etc/*-release 2>/dev/null | head -n 1)

  if [ ! -z "$RELEASE_INFO" ]; then
    OS=$(printf "$RELEASE_INFO" | awk '{ print $1 }')
    VER=$(printf "$RELEASE_INFO" | awk '{ print $NF }')
  else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
  fi
fi

# Convert OS name to lowercase to remove inconsistencies
OS=$(printf "$OS" | awk '{ print tolower($1) }')

printf "%s" "$OS"



export PATH=/opt/rakudo-pkg/bin:$PATH
set -e

case "$OS" in
  alpine)
    apk update --wait 120
    apk add --wait 120 curl perl bash git
  ;;
  amazon|centos|red)
    yum -q -y install make curl perl bash redhat-lsb-core git
    rm -rf /etc/yum.repos.d/rakudo-pkg.repo
    echo -e "[rakudo-pkg]\nname=rakudo-pkg\nbaseurl=https://dl.bintray.com/nxadm/rakudo-pkg-rpms/`lsb_release -is`/`lsb_release -rs| cut -d. -f1`/x86_64\ngpgcheck=0\nenabled=1" | tee -a /etc/yum.repos.d/rakudo-pkg.repo
    yum -q -y install rakudo-pkg
  ;;
  arch|archlinux)
    pacman -Syy
    pacman -S --needed --noconfirm -q curl perl bash git
    pacman -S --needed --noconfirm -q rakudo
  ;;
  debian|ubuntu)
    DEBIAN_FRONTEND=noninteractive
    apt-get update -q -o Dpkg::Use-Pty=0
    apt-get install -q -y -o Dpkg::Use-Pty=0 build-essential curl perl bash git lsb-release apt-transport-https ca-certificates 
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 379CE192D401AB61
    rm -rf /etc/apt/sources.list.d/rakudo-pkg.list
    echo "deb https://dl.bintray.com/nxadm/rakudo-pkg-debs `lsb_release -cs` main" | tee -a /etc/apt/sources.list.d/rakudo-pkg.list
    apt-get update -qq && apt-get install -q -y -o Dpkg::Use-Pty=0 rakudo-pkg
  ;;
  fedora)
    dnf -yq install curl perl bash redhat-lsb-core git
    rm -rf /etc/yum.repos.d/rakudo-pkg.repo
    echo -e "[rakudo-pkg]\nname=rakudo-pkg\nbaseurl=https://dl.bintray.com/nxadm/rakudo-pkg-rpms/`lsb_release -is`/`lsb_release -rs| cut -d. -f1`/x86_64\ngpgcheck=0\nenabled=1" | tee -a /etc/yum.repos.d/rakudo-pkg.repo
    dnf -yq install rakudo-pkg
  ;;
  *)
    printf "Your OS (%s) is not supported\n" "$OS"
    exit 1
esac

zef install --/test --force-install https://github.com/melezhik/Sparrow6.git



