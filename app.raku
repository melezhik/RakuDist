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

    post -> 'ci', :%params {

      request-body -> (:$thing) {

        my $shell = q:to/END/;
        set -e
        token=$(curl -sf -d thing=%thing% http://rakudist.raku.org/queue)
        echo $token
        while true; do
          status=$(curl -sf http://rakudist.raku.org/sparky/status/$token)
          sleep 5
          echo $status
          if test "$status" -eq "1" || test "$status" -eq "-1"; then
            break
          fi
        done
        echo "status: $status"
        report=$(curl -sf http://rakudist.raku.org/sparky/report/raw/$token)
        echo "report: $report"
  
        if test "$status" -eq "-1"; then
          exit 1
        fi
  
END
  
        $shell.=subst("%thing%",$thing);
  
        content 'text/plain', $shell;
  
      }

    }

    post -> 'queue', :%params {

      my %conf = get-webui-conf();
    
      my $theme ;
    
      if %conf<ui> && %conf<ui><theme> {
        $theme = %conf<ui><theme>
      } else {
        $theme = "cosmo";
      }

      my $default-rakudo-version-commit = "002acb1be2ba2a47ef8a48c30c340d43df91abed";

      my %rakudo-version-to-sha = %(

        "default" =>  $default-rakudo-version-commit,
        "2020.05.1" =>  $default-rakudo-version-commit,
        "2020.05" => "40a82d8723470a58d2d0cdde4cb14f8d0e845c91",
        "2020.02.1" => "e22170b6edcb782eeebe2b5052a70a40391d677e",
        "2020.02" => "e51be2a177dcf7f8bed9709d09c34f11be137f13",
        "2020.01" => "abae9bb4a6b130d413b72a0952e2edd67a304aab",
        "2019.11" => "8fa2b0f6a413d88f5875179c24fc6cdae76528ea",
        "2019.07.1" => "40b13322c503808235d9fec782d3767eb8edb899",
        "2019.07" => "928810c6c1bd83a28ada9622d45350c9d9d49c2a",
        "2019.03.1" => "da2b758404eaec0440aca4e5b84ed1c9aa4322c2",
        "2019.03" => "47e34445f48430ade9f19bf76631b7d6adea5d84",
        "2018.12" => "eb08bd11eb9caed6bd5e6e7739c43f6f23b53216",
        "2018.11" => "e32ff7eecb94de88c3e4c7031380a3cb1e0dae45",
        "2018.10" => "3fa8fdb82ae31eb32f54d4f51094927701468c22",
        "2017.12" => "c84ed2942d224e4cd524fa389e0603e4e4642f77",
        "2016.12" => "b2a3441749878e338b0861b14b3b9433cc902f42",  
        "2015.12" => "ec386e5ff54a6e8028e74092d1a41cfccdc531d2"
      );

      request-body -> (:$thing, :$os = "debian", :$rakudo_version? = "default", :$sha?, :$client = "cli" ) {

        my $is-error = False; my $error-message;

        if  $thing ~~! /^^ \s* <[ \/ \: \w \d  \_ \- \. ]>+ \s* $$/ 
            or $os ~~! /^^ \s* 'debian' || 'centos' || 'ubuntu' || 'alpine'  \s* $$ / 
        { 
          $is-error = True;
          $error-message = "One of input parameters (module,os) is not valid."
        }


        if $sha && $sha ~~! /^^ \s* <[  \w \d   ]>+ \s* $$/ {
          $is-error = True;
          $error-message = "sha parameter is not valid."
        }

        if $is-error {

          if $client eq "webui" {

            template 'templates/main.crotmp', %( 
              thing => $thing, 
              sha => $sha,
              os => $os,
              is-error => True,
              error-message => $error-message,
              theme => $theme
            )

          } else {

            bad-request 'text/plain', 'Bad input parameters';

          }


        } else {

          my $trigger;

          my $rakudo-versions;

          if $sha {
              $rakudo-versions = $sha
          } else {
              $rakudo-versions = $rakudo_version
          }


          for $rakudo-versions.split(',') -> $rv {

            my $rakudo-commit-version = $sha ?? $sha !! %rakudo-version-to-sha{$rv};
 
            $trigger = queue-build %(
              thing => $thing, 
              rakudo_version => $rakudo-commit-version,
              rakudo-version-mnemonic => $rv,  
              os => $os 
            );
  
          }
          
  
          if $client eq "webui" {

           template 'templates/main.crotmp', %( 
              thing => $thing, 
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
    :host<localhost>, :port<4000>, :$application;

$service.start;

react whenever signal(SIGINT) {
    $service.stop;
    exit;
}

