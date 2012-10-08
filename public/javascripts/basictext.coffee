
class BasicText
  data: (data, elem) ->
    elem.append $("<p>#{data.content}</p>")
  handles: ["text"]

if window.handlerTypes? > 0
  window.handlerTypes.push BasicText
else
  window.handlerTypes = [BasicText]
