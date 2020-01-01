# RakuDist

Test Raku modules against different OS, Rakudo versions

# Automatic tests

I am working on tests get run automatically and reports get published to public domain,
so far module authors could run tests manually.

# Runs tests manually

Install Sparrowdo

`zef install --/test Sparrowdo`

Pull dicker images

`docker pull debian`

Run container

`docker run -t --rm --name $container-name docker`

Run tests

`sparrowdo --bootstrap --docker=$container-name --repo=http://repo.westus.cloudapp.azure.com/ --sparrowfile=modules/red/sparrowfile`

# Available reports

TBD

# Author

Alexey Melezhik

