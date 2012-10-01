
class BasicText
  data: (data, elem) ->
    elem.append(data.content)
  handles: ["text"]

if window.handlers
  window.handlerTypes.push BasicText
else
  window.handlerTypes = [BasicText]
