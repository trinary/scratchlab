class LoadAverage
  data: (data, elem) ->
    elem.append(data.value)
  handles: ["loadavg"]

if window.handlerTypes
  window.handlerTypes.push LoadAverage
else
  window.handlerTypes = [LoadAverage]
