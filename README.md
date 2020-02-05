# RakuDist

Test Raku modules against different OS, Rakudo versions

# OS supported

* debian
* centos
* alpine

# Rakudo versions supported

Any, see `rakudo-version` parameter in API section

# Run tests via API

Follow [docs/api.md](https://github.com/melezhik/RakuDist/blob/master/docs/api.md) 

# Low level API

Follow [docs/low.md](https://github.com/melezhik/RakuDist/blob/master/docs/api.md) 

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

