#!/bin/sh
while true ; do
  sleep 3
  t="`date +%s`000"
  l=`uptime | awk '{print $10*10}'`
  curl -X POST -d "{\"type\":\"loadavg\", \"value\": $l, \"timestamp\": $t}" -H 'Content-Type: application/json' http://localhost:3000/data
  echo
done
