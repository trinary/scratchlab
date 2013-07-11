#!/bin/sh
while true ; do
  sleep 3
  t="`date +%s`000"
  l=`uptime | awk '{print $10*10}'`
  curl -u "example: " -X POST -d "{\"type\":\"text\", \"content\": \"Text\"}" -H 'Content-Type: application/json' $1
  echo
done
