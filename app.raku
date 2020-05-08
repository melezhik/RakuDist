use Cro::HTTP::Router;
use Cro::HTTP::Server;
use Cro::WebApp::Template;
use RakuDist;

my $application = route {


    get -> {

      my %conf = get-webui-conf();
    
      my $theme ;
    
      if %conf<ui> && %conf<ui><theme> {
        $theme = %conf<ui><theme>
      } else {
        $theme = "cosmo";
      }
    
      template 'templates/main.crotmp', %( theme => $theme )

    }

    post -> 'queue', :%params {

      my %conf = get-webui-conf();
    
      my $theme ;
    
      if %conf<ui> && %conf<ui><theme> {
        $theme = %conf<ui><theme>
      } else {
        $theme = "cosmo";
      }

      request-body -> (:$thing, :$os = "debian", :$rakudo_version = "default", :$client = "cli" ) {

        if  $thing ~~! /^^ \s* <[ \/ \: \w \d  \_ \- \. ]>+ \s* $$/ 
            or ($rakudo_version || "default")  ~~! /^^ \s* <[ a .. z  \d ]>+ \s* $$ / 
            or $os ~~! /^^ \s* 'debian' || 'centos' || 'ubuntu' || 'alpine'  \s* $$ /  {

          if $client eq "webui" {

            template 'templates/main.crotmp', %( 
              thing => $thing, 
              rakudo_version => $rakudo_version,
              os => $os,
              is-error => True,
              theme => $theme
            )

          } else {

            bad-request 'text/plain', 'Bad input parameters';

          }


        } else {

          my $trigger = queue-build %(
            thing => $thing, 
            rakudo_version => $rakudo_version,
            os => $os 
          );
  
          if $client eq "webui" {

            template 'templates/main.crotmp', %( 
              thing => $thing, 
              rakudo_version => $rakudo_version,
              os => $os,
              is-queued => True,
              theme => $theme
            )
  
          } else {

            content 'text/plain', "$os/$trigger";

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

