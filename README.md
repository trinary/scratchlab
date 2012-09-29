# A collaborative scratch pad for data and code.

## To run
 * npm install
 * coffee app.coffee

Nodemon is handy for reloading the server when anything changes.

## To Use (consider this Readme Driven Development):

 * Fork
 * Run your repo somewhere
 * Post some data to /data

```
    POST /data
    {
       "type":"timeseries",
       "name":"loadavg",
       "value":1.2,
       "time":1348961737
    }
```
 * Write some code to interpret and take action that data (examples coming)

```coffeescript
class LineChart
  accepts: ["timeseries"]
  initialize: () ->
    console.log "tbd"
  data: (d) ->
    console.log "I got a data!"
```
 * Push your code to your repo, and everyone using it will see its effects immediately.
