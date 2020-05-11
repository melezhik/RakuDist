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
# Module Kind
thing=Kind 

# Github project
thing=https://github.com/Kaiepi/p6-Kind  

```

- `os`

Docker container OS. Optional

One of: `debian|centos|ubuntu|alpine`

- `rakudo_version`

Full SHA for rakudo source commit. Optional.

For example:

```
rakudo_version=ef90599e2b6fde85385633b373b706b89d546763
```

## Return 

Token. Use a token to track a build execution.

## Example of curl request

```shell
curl -d thing=https://github.com/Kaiepi/p6-Kind \
-d os=centos \
-d rakudo_version=ef90599e2b6fde85385633b373b706b89d546763 \
http://repo.westus.cloudapp.azure.com/rakudist2/queue
```

# Track build status

Use this base URL to track build statuses - `http://repo.westus.cloudapp.azure.com/sparky/`

## Get build status

`GET /status/$token`

## Return 

Build Status:

| http status | body | descritpion |
| ------------| ---- | ----------- |
| 200         | -2   | build queued |
| 200         | -1   | build failed |
| 200         | 0    | build is running |
| 404         |  ""  | build not found |


# Get build report

`GET /report/raw/$token`


## Bash automation example

```bash
token=$(curl -sf -d thing=Kind http://repo.westus.cloudapp.azure.com/rakudist2/queue)
echo $token
while true; do
  status=$(curl -sf http://repo.westus.cloudapp.azure.com/sparky/status/$token)
  sleep 5
  echo $status
  if test -z "$status" || test "$status" -eq "1" || test "$status" -eq "-1"; then
    break
  fi
done
echo "status: $status"
report=$(curl -sf http://repo.westus.cloudapp.azure.com/sparky/report/raw/$token)
echo "report: $report"
```

# Travis integration example

To test a GitHub project named `$project` on certain `$os`, just use RakuDist helper:

`curl -d thing=$thing http://repo.westus.cloudapp.azure.com/rakudist2/ci -s | bash`

For example to test `https://github.com/melezhik/sparrowdo` project on debian:

```yaml
language: minimal

script:
  - curl -d thing=https://github.com/melezhik/sparrowdo http://repo.westus.cloudapp.azure.com/rakudist2/ci -s | bash
```

# Available reports

Follow this link [http://repo.westus.cloudapp.azure.com/sparky/builds](http://repo.westus.cloudapp.azure.com/sparky/builds) to see RakuDist reports

# Thanks to

God, because "For the Lord gives wisdom; from his mouth come knowledge and understanding.", Proverbs 2:6

# Author

Alexey Melezhik

