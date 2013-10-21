# A collaborative scratch pad for data and code.

## Before running
 * ```npm install -g nodemon```
 * ```createdb scratchlab```

## To run
 * npm install
 * coffee app.coffee

Nodemon is handy for reloading the server when anything changes.

## To Use

 * Fork
 * Run your repo somewhere (requires Postgres, schema.sql has the tables)
 * Auth with GitHub (your own keys go in env vars)
 * Make a new channel (/new)
 * Post some data to /channels/CHANNEL_ID/data with the channel key as the user

```
    POST /data
    {
       "type":"timeline",
       "name":"loadavg",
       "value":1.2,
       "timestamp":1348961737000
    }
```

 * See what data types the system knows about and an example doc for each

```
    GET /types
    {
      "scatter": {
          "name": "random-scatter",
          "type": "scatter",
          "x": 21144,
          "y": 27267
      },
      "timeline": {
          "name": "loadavg",
          "timestamp": 1363560058920,
          "type": "timeline",
          "value": 1.2
      }
    }
```
 * Write some code to interpret and take action that data. Here's roughly what a d3 line chart in coffeescript is like:
```coffeescript
   class TimeLine
       @handles: ["timeline"]
       svg: null
       points: null
       type: "timeline"
       name: ""
       initialized: false
       margin:
           left: 60
           right: 40
           top: 40
           bottom:40

       constructor: (name) ->
           @name = name

       setup: () ->
           @initialized = true
           @svg = d3.select("##{@name}")
             .append "svg"
           @svg.attr
             width: $("##{@name}").width()
             height: $("##{@name}").height()

           @lineG = @svg.append("g")
           @lineG.attr("transform","translate(#{@margin.left},#{@margin.top})")

           @path = @lineG.append("path")
             .data([@points])
             .attr("class","timeline")
       data: (data) ->
           @points = new Array if @points == null
           @points.push data
           if @points.length > 200
             @points = @points.slice(-200)

           @clearAxes()
           @updateScales()
           @updateAxes()
           @drawAxes()
           @updateLine()

           @path = @svg.select(".timeline")
             .data([@points])
             .attr("d", (d) => @line d)

   window.handlerTypes.push TimeLine
```
