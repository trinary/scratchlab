#!/bin/sh
while true ; do
  t="`date +%s`000"
  f=`vm_stat | grep Pages\ free | awk '{print $3}'| cut -d'.' -f 1`
  f="${f}0"
  curl -X POST -d "{\"type\":\"freepages\", \"value\": $f, \"timestamp\": $t}" -H 'Content-Type: application/json' http://localhost:3000/data
  sleep 3
done
