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

