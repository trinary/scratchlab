#!/bin/sh
while true ; do
  sleep 1
  t=`date +%s000`
  l=`uptime | awk '{ print $10}'`
  curl -u "example:" -X POST -d "{\"type\":\"timeline\", \"name\":\"loadavg\", \"value\": $l, \"timestamp\": $t}" -H 'Content-Type: application/json' $1
done
