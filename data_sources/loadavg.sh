#!/bin/sh
while true ; do
  sleep 1
  t=`date +%s000`
  l=`uptime | awk '{print $(NF-2)}'`
  doc="{\"type\":\"timeline\", \"name\":\"loadavg\", \"value\": $l \"timestamp\": $t}"
  echo $doc
  curl -u "$2:" -X POST -d "$doc" -H 'Content-Type: application/json' $1
done
