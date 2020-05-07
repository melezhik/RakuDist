use Cro::HTTP::Router;
use Cro::HTTP::Server;
use Cro::WebApp::Template;
use RakuDist;

my $application = route {


    get -> {
      template 'templates/main.crotmp', %()
    }

    post -> 'queue', :%params {

      request-body -> (:$thing, :$os, :$rakudo_version, :$client ) {

        if  $thing ~~! /^^ \s* <[ \/ \: \w \d  \_ \- \. ]>+ \s* $$/ 
            or ($rakudo_version || "default")  ~~! /^^ \s* <[ a .. z  \d ]>+ \s* $$ / 
            or $os ~~! /^^ \s* 'debian' || 'centos' || 'ubuntu' || 'alpine'  \s* $$ /  {

          if $client eq "webui" {

            template 'templates/main.crotmp', %( 
              thing => $thing, 
              rakudo_version => $rakudo_version,
              os => $os,
              is-error => True
            )

          } else {

            bad-request 'text/plain', 'Bad input parameters';

          }


        } else {

          queue-build %(
            thing => $thing, 
            rakudo_version => $rakudo_version,
            os => $os 
          );
  
          if $client eq "webui" {

            template 'templates/main.crotmp', %( 
              thing => $thing, 
              rakudo_version => $rakudo_version,
              os => $os,
              is-queued => True
            )
  
          } else {

            content 'text/plain', 'build queued';

          }
  
        }
        
      
      }
    
    }


}

my Cro::Service $service = Cro::HTTP::Server.new:
    :host<localhost>, :port<10001>, :$application;

$service.start;

react whenever signal(SIGINT) {
    $service.stop;
    exit;
}

