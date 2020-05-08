docker ps
echo =========================================

ps uax| grep 'sparrowdo --no'|grep -v grep

for i in alpine debian centos ubuntu; do
  inst="$i-rakudist"
  echo "[$inst]"
  docker exec -i $inst ps uax
done

