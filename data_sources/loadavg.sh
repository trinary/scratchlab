#!/bin/sh
while true ; do
  sleep 3
  t="`date +%s`000"
  l=`uptime | ruby -ne 'puts $_.split(" ")[-2]'`
  curl -X POST -d "{\"type\":\"loadavg\", \"value\": $l, \"timestamp\": $t}" -H 'Content-Type: application/json' http://localhost:3000/data
done
