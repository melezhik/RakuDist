#!/usr/bin/perl

use Mojolicious::Lite;

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

  $out .= "\ncentos-rakudist\n";

  $out .= `docker exec -i centos-rakudist ps uax`;

  
  $c->render(text => "<pre>$out</pre>");

};

get '/rakudist' => sub {

  my $c = shift;

  open my $fh, "$ENV{HOME}/.rakudist_history";

  my @records = <$fh>;

  close $fh;

  my @history;

  for my $i(reverse @records) {
    chomp $i;
    next unless $i =~ /\S+/;
    my ($thing_to_run,$os,$type,$rakudo_version,$sync_mode,$id,$token) = split /\s+/, $i;
    push @history, 
      "<tr><td><a href=\"/rakudist/reports/$thing_to_run/$os/$id.txt\" target=\"_blank\">$thing_to_run</a></td>\n",
      "<td>",job_status($token),"</td>",
      "<td>",
      (scalar localtime($id)),
      "</td>\n",
      "<td>$os</td>\n",
      ($rakudo_version eq "default" ? "<td>$rakudo_version</td>\n" : "<td> <a href=\"https://github.com/rakudo/rakudo/commit/$rakudo_version\" target=\"_blank\">$rakudo_version</a></td>\n" ),
      "</tr>\n"
  }

  return $c->render(
    text => "Welcome to the RakuDist © - Raku Modules Distributions Test API.<hr>\n".
    "<a href=\"https://github.com/melezhik/RakuDist\" target=\"_blank\">github</a> | ".
    "<a href=\"/rakudist/api/status\" target=\"_blank\">status</a><hr>".
    "To run test against a default version: <code> curl -d os=centos http://repo.westus.cloudapp.azure.com/rakudist/api/run/\$module_name</code><br>\n".
    "To run test against a certain version: <code> curl -d os=centos -d rakudo_version=\$full_sha_commit http://repo.westus.cloudapp.azure.com/rakudist/api/run/\$module_name</code><br>\n".
    "To run test against a certain os: <code> curl -d os=debian http://repo.westus.cloudapp.azure.com/rakudist/api/run/\$module_name</code><br>\n".
    "To run test against git/gitlab: <code> curl -d os=centos -d project=\$author/\$project http://repo.westus.cloudapp.azure.com/rakudist/api/run/:github</code><br>\n".
    "<hr>\n".
    "<table border=1 cellpadding=4 cellspacing=4>\n<caption>Recent runs</caption>\n<tr><th>Module</th><th>Result</th><th>Date</th><th>OS</th><th>Rakudo Version</th></tr>\n".
    (join "", (@history)).
    "</table>"
  );

};


post '/rakudist/api/run/:thing' => sub {

  my $c = shift;

  my $thing = $c->stash('thing');
  my $os = $c->param('os');
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
      open my $fh, ">>", "$ENV{HOME}/.rakudist_history";
      print $fh "$thing_to_run $os $type $rakudo_version $sync_mode $id $out\n";
      close $fh;
    } else {
      $c->render(text => $out, status => 500)
    }
  }
};


post '/rakudist/api/job/status' => sub {

  my $c = shift;

  my $token = $c->param('token');

  $c->render(text => job_status($token));
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
    return "running"
  } else {
      if ( open(my $fh, "<", "/usr/share/repo/rakudist/reports/$docker_id/$id.txt")) {
        my $report = join "", <$fh>;
        close $fh;
        if ($report =~ /RakuDist: OK/){
         return "success"
       } else {
          return "fail"
        }
      } else {
        return "unknown"
      }
  }


};


 
