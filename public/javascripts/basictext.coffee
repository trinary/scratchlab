class BasicText
  data: (data, elem) ->
    elem.append $("<p>#{data.content}</p>")
  handles: ["text"]

console.log "adding text"
console.log "types are: ",window.handlerTypes
window.handlerTypes.push BasicText
console.log "types are now: ",window.handlerTypes
