#!/bin/sh
while true ; do
  t="`date +%s`000"
  f=`vm_stat | grep Pages\ free | awk '{print $3}'| cut -d'.' -f 1`
  f="${f}0"
  curl -u "$2:" -X POST -d "{\"type\":\"timeline\", \"name\": \"freepages\", \"value\": $f, \"timestamp\": $t}" -H 'Content-Type: application/json' $1
  sleep 3
done
