#!/bin/sh
while true ; do
  sleep 1.5
  t="`date +%s`000"
  l=$RANDOM
  curl -u "example: " -X POST -d "{\"type\":\"timeline\", \"name\":\"random\", \"value\": $l, \"timestamp\": $t}" -H 'Content-Type: application/json' $1
done
