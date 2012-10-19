#!/bin/sh
while true ; do
  t="`date +%s`000"
  f=`vm_stat | grep Pages\ free | awk '{print $3}'`
  f="${f}0"
  curl -X POST -d "{\"type\":\"free pages\", \"value\": $f, \"timestamp\": $t}" -H 'Content-Type: application/json' http://localhost:3000/data
  sleep 3
done
