# Low level API

Run RakuDist using Docker and Sparrowdo

# Why?

If one need to run custom scenarios on premise infrastructure, use a following work-flow based on Docker and Sparrowdo.

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

`sparrowdo --bootstrap --no_sudo --docker=debian-rakudist`
