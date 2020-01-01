set -e
cd /root/.sparrowdo
export PATH=/opt/rakudo-pkg/bin/:$PATH
export SP6_CONFIG=config.pl6
export SP6_REPO=http://repo.westus.cloudapp.azure.com
perl6 -MSparrow6::Task::Repository -e Sparrow6::Task::Repository::Api.new.index-update
perl6 -MSparrow6::DSL sparrowfile
