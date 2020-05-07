token=$(curl -s -d thing=Kind http://repo.westus.cloudapp.azure.com/rakudist2/queue)
echo $token
while true; do
  status=$(curl -s http://repo.westus.cloudapp.azure.com/sparky/status/$token)
  sleep 5
  echo $status
  if test -z "$status" || test "$status" -eq "1" || test "$status" -eq "-1"; then
    break
  fi
done
echo "result: $status"

#curl -L -s -d token=$token http://repo.westus.cloudapp.azure.com/rakudist/api/job/report

