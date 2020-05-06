use v6;

unit module RakuDist;

sub plugin-search ( %params ) is export {

  my $thing = %params<thing>;
  my $os = %params<os>;
  my $rakudo_version = %params<rakudo_version>;
  
  my $user = ('a' .. 'z').pick(10).join('');

  my $id = "{$user}.{DateTime.now}";

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
  
    spurt "%( 
        user => '$user', 
        project => '$thing', 
        scm => 'https://$type.com/$thing.git', 
        rakudo_version => '$rakudo_version' 
     )", "$dir/$config"
  
  # local project
  } elsif "{%*ENV<HOME>}/projects/RakuDist/modules/$thing".IO ~~ :d {
  
    $dir = "{%*ENV<HOME>}/projects/RakuDist/modules/$thing";
    $description = "local project $thing RakuDist test, default Rakudo version";
    $config = "config.pl6";
  
  # CPAN module
  } else {
  
    $dir = "{%*ENV<HOME>}/projects/RakuDist/modules/default";
    $description = "$thing module RakuDist test, $rakudo_version Rakudo version";
    $config = "conf/$id.pl6";
  
    spurt "%( 
      user => '$user', 
      module => '$thing', 
      rakudo_version => '$rakudo_version' 
     )", "$dir/$config";
  
  }
  
  spurt "{ 
    cwd =>  '$dir',
    conf => '$conf',
    description => '$description',
  }", "{%*ENV<HOME>}/projects/RakuDist/sparky/$os/.triggers/$id.pl6"
  

}
