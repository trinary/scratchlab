class BasicText
  data: (data, elem) ->
    elem.append $("<p class='text'>#{data.content}</p>")
  handles: ["text"]

window.handlerTypes.push BasicText
