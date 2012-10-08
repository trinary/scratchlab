class BasicText
  data: (data, elem) ->
    elem.append $("<p>#{data.content}</p>")
  handles: ["text"]

console.log "adding text"
window.handlerTypes.push BasicText
