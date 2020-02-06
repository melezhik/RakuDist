#!/usr/bin/perl

use Mojolicious::Lite;

get '/rakudist/api/status' => sub {

  my $c = shift;

  my $out = `docker ps`;

  $out .= "\n=========================================\n";

  $out .= `ps uax| grep 'sparrowdo --no'|grep -v grep`;

  $out .= "\n\nalpine-rakudist\n";

  $out .= `docker exec -i alpine-rakudist ps uax`;

  $out .= "\ndebian-rakudist\n";

  $out .= `docker exec -i debian-rakudist ps uax`;

  $out .= "\ncentos-rakudist\n";

  $out .= `docker exec -i centos-rakudist ps uax`;

  
  $c->render(text => "<pre>$out</pre>");

};

get '/rakudist' => sub {

  my $c = shift;

  return $c->render(text => "Welcome to RakuDist - easy way to test your Raku modules distributions across different OS");

};


post '/rakudist/api/run/:thing' => sub {

  my $c = shift;

  my $thing = $c->stash('thing');
  my $os = $c->param('os');
  my $project = $c->param('project');
  my $rakudo_version = $c->param('rakudo_version') || "default";
  my $sync_mode = $c->param('sync_mode') || "off";
  my $type = ($thing eq ":github") ? "github" : "basic";
  my $verbose = $c->param('verbose') || 0;

  my $thing_to_run;

  if ($type eq 'github' ){

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

  unless ($os=~/^(alpine|debian|centos)+$/) {
    return $c->render(text => "bad os param", status => 400)
  }

  my $id = time();

  my $out = `/usr/bin/rkd-run $thing_to_run $os $type $rakudo_version $sync_mode $id`;

  my $exit_code = $?;

  if ($sync_mode eq "on") {
    $c->res->headers->header('X-RakuDist-ExitCode' => $exit_code );
    $c->render(text => $out);
  } else {
    if ($exit_code == 0){
      $c->render(text => $out);
    } else {
      $c->render(text => $out, status => 500)
    }
  }
};


post '/rakudist/api/job/status' => sub {

  my $c = shift;

  my $token = $c->param('token');

  my ($id, $docker_id) = split /:/, $token;

  `ps ax | grep sparrowdo | grep -q "\\--prefix=$id \\--"`;
  
  my $exit_code = $?;

  if ($exit_code == 0){
    $c->render(text => "running");
  } else {
      if ( open(my $fh, "<", "/usr/share/repo/rakudist/reports/$docker_id/$id.txt")) {
        my $report = join "", <$fh>;
        close $fh;
        if ($report =~ /RakuDist: OK/){
         $c->render(text => "success" );
       } else {
          $c->render(text => "fail" );
        }
      } else {
        $c->render(text => "unknown");
      }
  }


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


 
