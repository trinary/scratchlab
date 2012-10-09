class LoadAverage
  data: (data, elem) ->
    elem.append $("<p class='load'>#{data.value}</p>")
  handles: ["loadavg"]

console.log "adding loadavg"
window.handlerTypes.push LoadAverage
