# RakuDist

Test Raku modules against different OS, Rakudo versions

# Run tests via API

Warning: an API server has limited capacity, throttling is enabled.

## Testing CPAN modules

POST /rakudist/api/run/$module_name

Post parameters:

- `module_name` 

Required. Raku module name

- `os` 

Required. Operation system (`alpine|debian`)

- `rakudo-version`
 
Optional. A name of rakudo version commit, should be full SHA

Examples:


- sync_mode

Optional. (`on|off`), if sync mode is `on` run test in synchronous mode ( give result immediately )

* Run test for `Date::Names` module

`curl -d os=debian http://repo.westus.cloudapp.azure.com/rakudist/api/run/Date::Names`

* Run test for `Kind` module, rakudo version `40b13322c503808235d9fec782d3767eb8edb899`

`curl -d os=debian -d rakudo_version=40b13322c503808235d9fec782d3767eb8edb899 -d sync_mode=on http://repo.westus.cloudapp.azure.com/rakudist/api/run/Kind`


* Run test for `Tomty`, synchronous mode:

`curl -d sync_mode=on -d os=debian -d sync_mode=on http://repo.westus.cloudapp.azure.com/rakudist/api/run/Kind -D - > report.txt`


Run tests in synchronous mode.

In synchronous mode tests are executed immediately without being placed in a queue. Please pay attention that RakuDist API server has limited capability,
so don't expect a huge performance in synchronous mode.


## Testing GitHub projects

To test modules with source code taken from GitHub project use following notation:

POST /rakudist/api/run/:github

With project post parameter:

- `project`

`author/guthub-project`

For example:

`curl -d project=melezhik/Tomty -d os=debian -d sync_mode=on http://repo.westus.cloudapp.azure.com/rakudist/api/run/:github`


## Testing projects in `modules/` folder


This is mostly useful for demonstration purposes and or when testing API it self.

One can run tests for projects located in `modules/(https://github.com/melezhik/RakuDist/tree/master/modules/` directory:

POST  /rakudist/api/run/$project

Where $project is sub-folder with `modules/(https://github.com/melezhik/RakuDist/tree/master/modules/` directory

For example, to run test for [modules/red-with-pg](https://github.com/melezhik/RakuDist/tree/master/modules/red-with-pg)  project:

`curl -d os=debian http://repo.westus.cloudapp.azure.com/rakudist/api/run/red-with-pg`


# Available reports

Follow this link - http://repo.westus.cloudapp.azure.com/rakudist/reports/ to see examples of test reports

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

user $user;

zef "Red", %(
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

