#!/bin/sh
while true ; do
  sleep 1.5
  t=`ruby -e 'puts (Time.now.to_f * 1000).to_i'`
  x=$RANDOM
  y=$RANDOM
  curl -u "example: " -X POST -d "{\"type\":\"scatter\", \"name\":\"random-scatter\", \"x\": $x, \"y\": $y, \"timestamp\": $t}" -H 'Content-Type: application/json' $1
done
