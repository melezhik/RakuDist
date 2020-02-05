# RakuDist

Test Raku modules against different OS, Rakudo versions

# OS supported

* debian
* centos
* alpine

# Rakudo versions supported

Any, see `rakudo-version` parameter in API section

# Run tests via API

Warning: an API server has limited capacity, throttling is enabled.

POST /rakudist/api/run/$module_name

Return - token. Use the token to track test execution

Get test status:

POST $token /rakudist/api/job/status

Return - status:

* `running` - a job is being executed
* `success` - a job succeeded
* `fail` - a job failed
* `unknown` - could not get a job status

Automation example:

```
token=$(curl -s -d os=debian http://repo.westus.cloudapp.azure.com/rakudist/api/run/Kind)
while true; do
  status=$(curl -s -d token=$token http://repo.westus.cloudapp.azure.com/rakudist/job/status)
  if test $status != "running"; then
    break
  fi
done
echo "test: $status"
curl -s -d token=$token http://repo.westus.cloudapp.azure.com/rakudist/job/report
```

## Testing CPAN modules

POST /rakudist/api/run/$module_name

### Post parameters

- `module_name` 

Required. Raku module name

- `os` 

Required. Operation system (`alpine|debian|centos`)

- `rakudo-version`
 
Optional. A name of rakudo version commit, should be full SHA

Caveats. Rakudo version option is available only for CPAN modules and on debian os.

* sync_mode

Optional. (`on|off`), if sync mode is `on` run test in synchronous mode ( gives result immediately )

### Examples:

* Run test for `Date::Names` module

`curl -d os=debian http://repo.westus.cloudapp.azure.com/rakudist/api/run/Date::Names`

* Run test for `Kind` module, rakudo version `40b13322c503808235d9fec782d3767eb8edb899`

`curl -d os=debian -d rakudo_version=40b13322c503808235d9fec782d3767eb8edb899 http://repo.westus.cloudapp.azure.com/rakudist/api/run/Kind`

### Run tests in synchronous mode.

_By default_ tests run in asynchronous mode, so requests placed in a queue and executed later. 
To track a test status use a token returned by request:


```
token=$(curl -s -d os=debian http://repo.westus.cloudapp.azure.com/rakudist/api/run/Kind)
curl -d token=$token http://repo.westus.cloudapp.azure.com/rakudist/api/job/status
```
To print out test report:

`curl -d token=$token http://repo.westus.cloudapp.azure.com/rakudist/api/job/status`

In synchronous mode tests are executed immediately without being placed in a queue. 

Test report comes with body and test exicode (`0` for success ) is delivered through `X-RakuDist-ExitCode` header.

Example.

Run synchronous run test for `Tomty` module:

`curl -d sync_mode=on -d os=debian -d sync_mode=on http://repo.westus.cloudapp.azure.com/rakudist/api/run/Kind -D -`

Caveats:

* Sync mode is available only for CPAN modules

* RakuDist API server has limited capability, so don't expect a huge performance in synchronous mode and try not to overload it (-; !

## Testing GitHub projects

To test modules with a source code taken from GitHub project use a following notation:

POST /rakudist/api/run/:github

With project post parameter:

- `project`

`author/guthub-project`

For example:

`curl -d project=melezhik/Tomty -d os=debian http://repo.westus.cloudapp.azure.com/rakudist/api/run/:github`


## Testing projects in `modules/` folder

This is mostly useful for demonstration purposes and or when testing API it self.

One can run tests for projects located in [modules](https://github.com/melezhik/RakuDist/tree/master/modules/) directory:

POST  /rakudist/api/run/$project

Where $project is a sub-folder within [modules](https://github.com/melezhik/RakuDist/tree/master/modules/) directory

For example, to run test for [modules/red-with-pg](https://github.com/melezhik/RakuDist/tree/master/modules/red-with-pg)  project:

`curl -d os=debian http://repo.westus.cloudapp.azure.com/rakudist/api/run/red-with-pg`

# Available reports

Follow this link http://repo.westus.cloudapp.azure.com/rakudist/reports/ to see examples of test reports

# RakuDistAPI status

Status page shows docker containers statues and current queue

http://repo.westus.cloudapp.azure.com/rakudist/api/status

# Low level API

If one need to run custom scenarios and run them on premise infrastructure, use a following work-flow
to run custom test scenarios on docker containers:

## Install Sparrowdo

`zef install --/test Sparrowdo`

## Pull docker images

`docker pull debian`

## Run container

`docker run -d -t --rm --name debian-rakudist debian`

## Write test

Test scenarios are written on [Sparrow6 DSL](https://github.com/melezhik/Sparrow6/blob/master/documentation/dsl.md)

`cat sparrowfile`

```
package-install "sqlite-libs";

my $user = "red";
my $module = "Red";

user $user;

zef $module, %(
  force => False,
  depsonly => True,
  notest => True,
  user => $user,
  description => "Install $module dependencies"
);

zef $module, %(
  force => False,
  user => $user,
  description => "Install $module"
);

```

See various examples of test scenarios in `modules/` folder.

## Run test

`sparrowdo --bootstrap --no_sudo --docker=debian-rakudist --repo=http://repo.westus.cloudapp.azure.com`

# See also

* [Sparrow6](https://github.com/melezhik/Sparrow6)
* [Sparrow6 DSL](https://github.com/melezhik/Sparrow6/blob/master/documentation/dsl.md)
* [Sparrowdo](https://github.com/melezhik/sparrowdo)

# Thanks to

God, because "For the Lord gives wisdom; from his mouth come knowledge and understanding.", Proverbs 2:6

# Author

Alexey Melezhik

