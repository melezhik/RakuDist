use v6;

unit module RakuDist;
use YAMLish;

sub queue-build ( %params ) is export {

  my $thing = %params<thing>;
  my $os = %params<os>;
  my $rakudo_version = %params<rakudo_version> || "default";
  my $rakudo-version-mnemonic = %params<rakudo-version-mnemonic>;

  my $user = ('a' .. 'z').pick(20).join('');

  my $id = "{$user}{$*PID}";

  my $type;

  if $thing ~~ s/^^ \s* 'https://github.com/'// {
    $type = "github"
  } elsif $thing ~~ s/^^ \s* 'https://gitlab.com/'// {
    $type = "gitlab"
  } elsif $thing ~~ s/^^ \s* 'https://home.tyil.nl/git/'// {
    $type = "tyilgit"
  } elsif "{%*ENV<HOME>}/projects/RakuDist/modules/$thing".IO ~~ :d {
    $type = "local"
  } else {
    $type = "cpan";
  }


  my $description;

  my $effective-dir = "{%*ENV<HOME>}/projects/RakuDist/.cache/{$user}";

  mkdir $effective-dir;

  # github/gitlab project
  if ( $type eq "github" or $type eq "gitlab" ) {

    shell "cp -r {%*ENV<HOME>}/projects/RakuDist/modules/default-github/* $effective-dir";

    $description = "$type project $thing RakuDist test, $rakudo-version-mnemonic Rakudo version";

    spurt "$effective-dir/config.pl6", "%(
        user => '$user',
        project => '$thing',
        scm => 'https://$type.com/$thing',
        rakudo_version => '$rakudo_version'
     )";

   # tyilgit project
   } elsif $type eq "tyilgit"  {

    shell "cp -r {%*ENV<HOME>}/projects/RakuDist/modules/default-github/* $effective-dir";

    $description = "$type project $thing RakuDist test, $rakudo-version-mnemonic Rakudo version";

    spurt "$effective-dir/config.pl6", "%(
        user => '$user',
        project => '$thing',
        scm => 'https://home.tyil.nl/git/$thing',
        rakudo_version => '$rakudo_version'
     )";

  # local project

  } elsif $type eq "local" {


    shell "cp -r {%*ENV<HOME>}/projects/RakuDist/modules/$thing/* $effective-dir";

    $description = "local project $thing RakuDist test, default Rakudo version";

  # CPAN module
  } else {

    shell "cp -r {%*ENV<HOME>}/projects/RakuDist/modules/default/* $effective-dir";

    $description = "$thing module RakuDist test, $rakudo-version-mnemonic Rakudo version";

    spurt "$effective-dir/config.pl6", "%(
      user => '$user',
      module => '$thing',
      rakudo_version => '$rakudo_version'
     )";

  }

  mkdir "{%*ENV<HOME>}/projects/RakuDist/sparky/$os/.triggers/";


  spurt "{%*ENV<HOME>}/projects/RakuDist/sparky/$os/.triggers/$id", "%(
    cwd =>  '$effective-dir',
    conf => 'config.pl6',
    description => '$description',
  )";

  say "queue build: {%*ENV<HOME>}/projects/RakuDist/sparky/$os/.triggers/$id: ",
      "{%*ENV<HOME>}/projects/RakuDist/sparky/$os/.triggers/$id".IO.slurp;

  return $id

}

sub get-webui-conf is export {

  my $conf-file = %*ENV<HOME> ~ '/rakudist-web.yaml';

  my %conf = $conf-file.IO ~~ :f ?? load-yaml($conf-file.IO.slurp) !! Hash.new;

  #warn "rakudist web conf loaded: ", $conf-file;

  %conf;

}

