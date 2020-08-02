my @hosts = [
  %( host => "docker:alpine-rakudist", tags => "alpine,os=alpine" ),
  %( host => "docker:debian-rakudist", tags => "debian,os=debian" ),
  %( host => "docker:centos-rakudist", tags => "centos,os=centos" ),
  %( host => "docker:ubuntu-rakudist", tags => "ubuntu,os=ubuntu" ),
];

use Data::Dump;


say Dump(@hosts);

@hosts;
