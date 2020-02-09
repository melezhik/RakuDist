# RakuDist API

API allows to run Raku distributions tests through public API

Warning: an API server has limited capacity, throttling is enabled.

# Main workflow

Usually one start new test against a _module_: 

POST /rakudist/api/run/$module_name

Return - token. Use the token to track test execution.

And polls test status and results, as test job runs in asynchronous mode:

POST $token /rakudist/api/job/status

Return - status:

* `running` - a job is being executed
* `success` - a job succeeded
* `fail` - a job failed
* `unknown` - could not get a job status


# Travis integration example

To test a github project named `$project` on certain `$os`, just use RakuDist helper:

`curl http://repo.westus.cloudapp.azure.com/rakudist/api/run/$os/$author/$project -s | bash`

For example to test `https://github.com/melezhik/sparrowdo` project on debian:

```yaml
language: minimal

script:
  - curl http://repo.westus.cloudapp.azure.com/rakudist/api/run/debian/melezhik/sparrowdo -s | bash
```


# Shell script example

```shell
token=$(curl -s -d os=debian http://repo.westus.cloudapp.azure.com/rakudist/api/run/Kind)
echo $token
while true; do
  status=$(curl -s -d token=$token http://repo.westus.cloudapp.azure.com/rakudist/api/job/status)
  sleep 5
  echo $status
  if [ $status != "running" ]; then
    break
  fi
done
echo "test: $status"
curl -L -s -d token=$token http://repo.westus.cloudapp.azure.com/rakudist/api/job/report
```

# Testing various types of "things"

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

* `sync_mode`

Optional. (`on|off`), if sync mode is `on` run test in synchronous mode ( gives result immediately )

### Examples:

* Run test for `Date::Names` module

`curl -d os=debian http://repo.westus.cloudapp.azure.com/rakudist/api/run/Date::Names`

* Run test for `Kind` module, rakudo version `40b13322c503808235d9fec782d3767eb8edb899`

`curl -d os=debian -d rakudo_version=40b13322c503808235d9fec782d3767eb8edb899 http://repo.westus.cloudapp.azure.com/rakudist/api/run/Kind`

## Testing GitHub/GitLab projects

To test modules with a source code taken from GitHub/GitLab project use a following notation:

POST /rakudist/api/run/:(github|gitlab)

Post parameters

- `project`

`author/project`

For example to test `melezhik/Tomty` on GitHub:

`curl -d project=melezhik/Tomty -d os=debian http://repo.westus.cloudapp.azure.com/rakudist/api/run/:github`

## Testing projects in `modules/` folder

This is mostly useful for demonstration purposes and or when testing API it self.

One can run tests for projects located in [modules](https://github.com/melezhik/RakuDist/tree/master/modules/) directory:

POST  /rakudist/api/run/$project

Where $project is a sub-folder within [modules](https://github.com/melezhik/RakuDist/tree/master/modules/) directory

For example, to run test for [modules/red-with-pg](https://github.com/melezhik/RakuDist/tree/master/modules/red-with-pg)  project:

`curl -d os=debian http://repo.westus.cloudapp.azure.com/rakudist/api/run/red-with-pg`

# Run tests in synchronous mode.

_By default_ tests run in asynchronous mode, so requests placed in a queue and executed later:

`token=$(curl -s -d os=debian http://repo.westus.cloudapp.azure.com/rakudist/api/run/Kind)`

To track a job status use a token returned by request:

`status =$curl -d token=$token http://repo.westus.cloudapp.azure.com/rakudist/api/job/status)`

To print out job report:

`curl -L -d token=$token http://repo.westus.cloudapp.azure.com/rakudist/api/job/status`

In synchronous mode tests are executed immediately without being placed in a queue. 

Test report comes with body and test exicode (`0` for success ) is delivered through `X-RakuDist-ExitCode` header.

Example. Run synchronous run test for `Tomty` module:

`curl -d sync_mode=on -d os=debian -d sync_mode=on http://repo.westus.cloudapp.azure.com/rakudist/api/run/Kind -D -`

Caveats:

* Sync mode is available only for CPAN modules

* RakuDist API server has limited capability, so don't expect a huge performance in synchronous mode and try not to overload it (-; !

# Available reports

Follow this link http://repo.westus.cloudapp.azure.com/rakudist/reports/ to see examples of test reports

# RakuDistAPI status

Status page shows docker containers statues and current queue

http://repo.westus.cloudapp.azure.com/rakudist/api/status

# Thanks to

God, because "For the Lord gives wisdom; from his mouth come knowledge and understanding.", Proverbs 2:6

# Author

Alexey Melezhik

