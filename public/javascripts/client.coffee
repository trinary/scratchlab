$ ->
  socket = io.connect 'http://localhost'

  for t in window.handlerTypes
    window.handlers = []
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
    for h in window.handlers
      # TODO: make this conditional on the contents of h.handles
      h.data(data, $('.view'))

