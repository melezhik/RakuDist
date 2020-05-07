# RakuDist API

API allows to run Raku distributions tests through public API

Warning: an API server has limited capacity, throttling is enabled.

# Base API URL

Use this base URL to interact with API - `http://repo.westus.cloudapp.azure.com/rakudist2`

# Queue build

`POST /rakudist2/queue`

## Parameters

- `thing`

Either a Raku module name or GitHub/GitLab project URL. Required.

Examples:

```

thing=Kind # Module Kind

thing=https://github.com/Kaiepi/p6-Kind # Github project 

```

- `os`

One of: `debian|centos|ubuntu|alpine`

- `rakudo_version`

Full SHA for rakudo source commit. Optional.

For example:

```
rakudo_version= ef90599e2b6fde85385633b373b706b89d546763
```

## Return 

Token. Use this token to track a build execution.

# Track build status

Use this base URL to track build statues - `http://repo.westus.cloudapp.azure.com/sparky/`

`GET builds/key/$token/status`

## Return 

Status:

* `queued` - a build is queued
* `running` - a build is being executed
* `success` - a build succeeded
* `fail` - a build failed
* `unknown` - could not get a build status

# Travis integration example

To test a GitHub project named `$project` on certain `$os`, just use RakuDist helper:

`curl http://repo.westus.cloudapp.azure.com/rakudist2/travis/run/$os/$author/$project -s | bash`

For example to test `https://github.com/melezhik/sparrowdo` project on debian:

```yaml
language: minimal

script:
  - curl http://repo.westus.cloudapp.azure.com/rakudist2/travis/run/debian/melezhik/sparrowdo -s | bash
```

# Available reports

Follow this link [http://repo.westus.cloudapp.azure.com/sparky/builds](http://repo.westus.cloudapp.azure.com/sparky/builds) to see RakuDist reports

# Thanks to

God, because "For the Lord gives wisdom; from his mouth come knowledge and understanding.", Proverbs 2:6

# Author

Alexey Melezhik

