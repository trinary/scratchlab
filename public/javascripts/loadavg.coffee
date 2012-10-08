class LoadAverage
  data: (data, elem) ->
    elem.append $("<p>#{data.value}</p>")
  handles: ["loadavg"]

console.log "adding loadavg"
#window.handlerTypes.push LoadAverage
