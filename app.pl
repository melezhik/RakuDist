#!/usr/bin/perl

use Mojolicious::Lite;
use Data::UUID;

my @recent;

get '/rakudist/api/status' => sub {

  my $c = shift;

  my $out = `docker ps`;

  $out .= "\n=========================================\n";

  $out .= `ps uax| grep 'sparrowdo --no'|grep -v grep`;

  $out .= "\n\nalpine-rakudist\n";

  $out .= `docker exec -i alpine-rakudist ps uax`;

  $out .= "\ndebian-rakudist\n";

  $out .= `docker exec -i debian-rakudist ps uax`;

  $out .= "\nubuntu-rakudist\n";

  $out .= `docker exec -i ubuntu-rakudist ps uax`;

  $out .= "\ncentos-rakudist\n";

  $out .= `docker exec -i centos-rakudist ps uax`;

  
  $c->render(text => "<pre>$out</pre>");

};

get '/rakudist' => sub {

  my $c = shift;


  return $c->render(
    text => "Welcome to the RakuDist © - Raku Modules Distributions Test API.<hr>\n".
    "<a href=\"https://github.com/melezhik/RakuDist\" target=\"_blank\">github</a> | \n".
    "<a href=\"/rakudist/api/status\" target=\"_blank\">status</a><hr>\n".
    "OS supported: Debian/Centos/Alpine/Ubuntu<hr>\n".
    "to run test against a default version: <pre>curl -d os=centos http://repo.westus.cloudapp.azure.com/rakudist/api/run/\$module_name</pre><br>\n".
    "to run test against a certain version: <pre> curl -d os=centos -d rakudo_version=\$full_sha_commit http://repo.westus.cloudapp.azure.com/rakudist/api/run/\$module_name</pre><br>\n".
    "to run test against a certain os: <pre> curl -d os=debian http://repo.westus.cloudapp.azure.com/rakudist/api/run/\$module_name</pre><br>\n".
    "to run test against git/gitlab: <pre> curl -d os=centos -d project=\$author/\$project http://repo.westus.cloudapp.azure.com/rakudist/api/run/:github</pre><br>\n".
    "<hr>Go to <a href=\"http://repo.westus.cloudapp.azure.com/sparky/builds\">http://repo.westus.cloudapp.azure.com/sparky/builds</a> to see current builds.\n"
  );

};


post '/rakudist/api/run/:thing' => sub {

  my $c = shift;

  my $thing = $c->stash('thing');
  my $os = $c->param('os');
  my $sparky = 1;
  my $project = $c->param('project');
  my $rakudo_version = $c->param('rakudo_version') || "default"; # "abae9bb4a6b130d413b72a0952e2edd67a304aab";
  my $sync_mode = $c->param('sync_mode') || "off";

  my $type = "basic";

  if ($thing eq ":github") {
    $type = "github"
  } elsif ($thing eq ":gitlab") {
    $type = "gitlab"
  }

  my $verbose = $c->param('verbose') || 0;

  my $thing_to_run;

  if ($type eq 'github' or $type eq 'gitlab'){

    unless ($project=~/^\S+\/\S+$/) {
      return $c->render(text => "bad project param", status => 400)
    }

    $thing_to_run = $project

  } else {

    $thing_to_run = $thing
    
  }

  unless ($os) {
    return $c->render(text => "os param is required", status => 400)
  }

  unless ($thing=~/^([\w+\-\d:])+$/) {
    return $c->render(text => "bad project param", status => 400)
  }

  unless ($os=~/^(alpine|debian|centos|ubuntu)+$/) {
    return $c->render(text => "bad os param", status => 400)
  }

  my $id = Data::UUID->new->to_string;

  my $out;

  if ($sparky){
    $out = `/usr/bin/rkd-run-sparky $thing_to_run $os $type $rakudo_version $sync_mode $id`;
 } else {
    $out = `/usr/bin/rkd-run $thing_to_run $os $type $rakudo_version $sync_mode $id`;
  }

  my $exit_code = $?;

  if ($sync_mode eq "on") {
    $c->res->headers->header('X-RakuDist-ExitCode' => $exit_code );
    $c->render(text => $out);
  } else {
    if ($exit_code == 0){
      if ($sparky){
        $c->render(text => "build is queued to Sparky");
      } else {
        $c->render(text => $out);
        open my $fh, ">>", "$ENV{HOME}/.rakudist_history";
        print $fh "$thing_to_run $os $type $rakudo_version $sync_mode $id $out";
        close $fh;
      }
    } else {
      $c->render(text => $out, status => 500)
    }
  }
};


post '/rakudist/api/job/status' => sub {

  my $c = shift;

  my $token = $c->param('token');

  $c->render(text => job_status($token)->{status});

};

post '/rakudist/api/job/report' => sub {

  my $c = shift;

  my $token = $c->param('token');

  $token =~ /(\d+?):(\S+)/;

  my $id = $1; my $docker_id = $2;

  $c->redirect_to("/rakudist/reports/$docker_id/$id.txt");

};

get '/rakudist/api/run/:os/:author/:project/' => sub {

  my $c = shift;

  my $os = $c->param('os');

  my $author = $c->param('author');

  my $project = $c->stash('project');

  
  my $cmd = <<'HERE';

  token=$(curl -s -d os=%os% -d project=%a%/%p% http://repo.westus.cloudapp.azure.com/rakudist/api/run/:github)
  while true; do
    status=$(curl -s -d token=$token http://repo.westus.cloudapp.azure.com/rakudist/api/job/status)
    sleep 5
    echo -n .
    if [ $status != "running" ]; then
      break
    fi
  done
  echo
  echo "test: $status"
  curl -L -s -d token=$token http://repo.westus.cloudapp.azure.com/rakudist/api/job/report
  if [ $status != "success" ]; then
    exit 1
  fi
  

HERE

  $cmd=~s/%os%/$os/;

  $cmd=~s/%a%/$author/;

  $cmd=~s/%p%/$project/;

  $c->render(text => $cmd);

};

app->start;

sub job_status {

  my $token = shift;

  $token =~ /(\d+?):(\S+)/;

  my $id = $1; my $docker_id = $2;

  `ps ax | grep sparrowdo | grep -q "\\--prefix=$id \\--"`;
  
  my $exit_code = $?;

  if ($exit_code == 0){

      if ( open(my $fh, "<", "/usr/share/repo/rakudist/reports/$docker_id/$id.txt")) {

        my $report = join "", <$fh>;

        close $fh;

        return $report =~ /perl6\s+version\]\s+(.*)/ ? { status => "running", version => $1 } : { status => "running" } 

      } else {
        return { status => "running" }
      }
  } else {
      if ( open(my $fh, "<", "/usr/share/repo/rakudist/reports/$docker_id/$id.txt")) {
        my $report = join "", <$fh>;
        close $fh;
        if ($report =~ /RakuDist: OK/){
         return $report =~ /perl6\s+version\]\s+(.*)/ ? { status => "success", version => $1 } : { status => "success" } 
         } else {
         $report =~ /perl6\s+version\]\s+(.*)/; 
         return $report =~ /perl6\s+version\]\s+(.*)/ ? { status => "fail", version => $1 } : { status => "fail" } 
        }
      } else {
        return { status => "unknown" }
      }
  }


};


 
