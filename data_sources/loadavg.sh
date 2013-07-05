#!/bin/sh
while true ; do
  sleep 0.5
  t=`ruby -e 'puts (Time.now.to_f * 1000).to_i'`
  l=`uptime | ruby -ne 'puts $_.split(" ")[-2]'`
  curl -u "example:" -X POST -d "{\"type\":\"timeline\", \"name\":\"loadavg\", \"value\": $l, \"timestamp\": $t}" -H 'Content-Type: application/json' http://localhost:3000/channels/094314fcefaba46c483ba1e6d9761f67938ff468/data
done
