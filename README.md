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

 * See what data types the system knows about and an example doc for each

```
   GET /types
   {
        "type":"text"
        "example": {
            "type":"text",
            "name":"example",
            "content":"This is an example of a datatype example."
        }
    }
```
 * Write some code to interpret and take action that data (real examples coming - TODO)

```coffeescript
class LineChart
  accepts: ["timeseries"]
  initialize: () ->
    console.log "tbd"
  data: (d, e) ->
    e.append data.whatever
```
 * Push your code to your repo, and everyone using it will see its effects immediately. (TODO)
