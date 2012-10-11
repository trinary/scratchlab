class LoadAverage
  data: (data, elem) ->
    elem.append $("<p class='load'>#{data.value}</p>")
  handles: ["loadavg"]
  name: "loadavg"

window.handlerTypes.push LoadAverage
