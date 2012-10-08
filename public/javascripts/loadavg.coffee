class LoadAverage
  data: (data, elem) ->
    elem.append $("<p>#{data.value}</p>")
  handles: ["loadavg"]

if window.handlerTypes? > 0
  window.handlerTypes.push LoadAverage
else
  window.handlerTypes = [LoadAverage]
