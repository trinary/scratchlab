$ ->
  console.log "jq ready firing in client.coffee"
  socket = io.connect window.location

  window.handlers = []
  for t in window.handlerTypes
    window.handlers.push new t

  socket.on 'reload', (what) -> 
    console.log what 
    $('.flash').append "<div class='warning'>New Code recieved, reloading...</div>"
    setTimeout ->
      window.location.reload()
    , 5000

  socket.on 'data', (data) ->
    console.log "Got new data", data
    type = data.type
    console.log window.handlers
    for h in window.handlers
      console.log h.handles, data.type
      if _.contains h.handles, data.type
        console.log "it does!"
        h.data(data, $('.view')) 
      else
        console.log "it doesn't!"

