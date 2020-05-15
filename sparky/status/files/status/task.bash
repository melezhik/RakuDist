docker ps
echo =========================================

ps uax| grep 'sparrowdo --no'|grep -v grep

for i in debian; do
  inst="$i-rakudist"
  echo "[$inst]"
  docker exec -i $inst ps uax
done

