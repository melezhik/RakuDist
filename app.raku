use Cro::HTTP::Router;
use Cro::HTTP::Server;
use Cro::WebApp::Template;

my $application = route {


    get -> {
      template 'templates/main.crotmp', %()
    }


}

my Cro::Service $service = Cro::HTTP::Server.new:
    :host<localhost>, :port<10001>, :$application;

$service.start;

react whenever signal(SIGINT) {
    $service.stop;
    exit;
}

