#!/bin/sh
while true ; do
  sleep 1.5
  t=`ruby -e 'puts (Time.now.to_f * 1000).to_i'`
  value=$RANDOM
  curl -X POST -d "{\"type\":\"histogram\", \"name\": \"random-histo\", \"value\": $value, \"timestamp\": $t}" -H 'Content-Type: application/json' http://127.0.0.1:3000/data
done
