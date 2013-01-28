$ ->
  socket = io.connect window.location

  window.handlers = []
  for t in window.handlerTypes
    window.handlers.push new t

  socket.on 'reload', (what) -> 
    $('.flash').append "<div class='warning'>New Code recieved, reloading...</div>"
    setTimeout ->
      window.location.reload()
    , 5000

  socket.on 'data', (data) ->
    console.log "I got a data?"
    console.log data
    type = data.type
    for h in window.handlers
      name = h.name
      view = $('.view')
      target = view.find("##{name}") 
      target = $("<div class=\"handler\" id=\"#{name}\"></div>").appendTo view unless target.length > 0
      if _.contains h.handles, data.type
        h.setup if h.initialized == false
        h.data(data, target) 

