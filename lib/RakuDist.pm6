use v6;

unit module RakuDist;

sub queue-build ( %params ) is export {

  my $thing = %params<thing>;
  my $os = %params<os>;
  my $rakudo_version = %params<rakudo_version> || "default";
  
  my $user = ('a' .. 'z').pick(20).join('');

  my $id = "{$user}{$*PID}";

  my $type;
  
  if $thing ~~ s/^^ \s* 'https://github.com/'// {
    $type = "github"
  } elsif $thing ~~ s/^^ \s* 'https://gitlab.com/'// {
    $type = "gitlab"
  } elsif "{%*ENV<HOME>}/projects/RakuDist/modules/$thing".IO ~~ :d {
    $type = "local"
  } else {
    $type = "cpan";
  }


  my $dir;
  my $description;
  my $config;

  # github/gitlab project
  if ( $type eq "github" or $type eq "gitlab" ) {
  
    $dir = "{%*ENV<HOME>}/projects/RakuDist/modules/default-github";
    $description = "$type project $thing RakuDist test, $rakudo_version Rakudo version";
    $config = "conf/$id.pl6";
  
    spurt "$dir/$config", "%( 
        user => '$user', 
        project => '$thing', 
        scm => 'https://$type.com/$thing.git', 
        rakudo_version => '$rakudo_version' 
     )";
  
  # local project
  } elsif $type eq "local" {
  
    $dir = "{%*ENV<HOME>}/projects/RakuDist/modules/$thing";
    $description = "local project $thing RakuDist test, default Rakudo version";
    $config = "config.pl6";
  
  # CPAN module
  } else {
  
    $dir = "{%*ENV<HOME>}/projects/RakuDist/modules/default";
    $description = "$thing module RakuDist test, $rakudo_version Rakudo version";
    $config = "conf/$id.pl6";
  
    spurt "$dir/$config", "%( 
      user => '$user', 
      module => '$thing', 
      rakudo_version => '$rakudo_version' 
     )";
  
  }
  
  spurt "{%*ENV<HOME>}/projects/RakuDist/sparky/$os/.triggers/$id.pl6", "%( 
    cwd =>  '$dir',
    conf => '$config',
    description => '$description',
  )";

  say "queue build: {%*ENV<HOME>}/projects/RakuDist/sparky/$os/.triggers/$id.pl6:", 
      "{%*ENV<HOME>}/projects/RakuDist/sparky/$os/.triggers/$id.pl6".IO.slurp;  

  return "$id.pl6"

}
