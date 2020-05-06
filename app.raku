use Cro::HTTP::Router;
use Cro::HTTP::Server;
use Cro::WebApp::Template;
use RakuDist;

my $application = route {


    get -> {
      template 'templates/main.crotmp', %()
    }

    post -> 'queue', :%params {

      request-body -> (:$thing, :$os, :$rakudo_version) {
        
        queue-build %(
          thing => $thing, 
          rakudo_version => $rakudo_version,
          os => $os 
        );
        
        template 'templates/main.crotmp', %( 
          thing => $thing, 
          rakudo_version => $rakudo_version,
          os => $os 
        )
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

