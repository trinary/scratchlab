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
    type = data.type
    for h in window.handlers
      name = h.name
      view = $('.view')
      target = view.find(".#{name}") 
      target = view.append("<div class=\"#{name}\"></div>") unless target.length > 0
      h.data(data, target) if _.contains h.handles, data.type

