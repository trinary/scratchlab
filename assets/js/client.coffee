loc = window.location.protocol + "//" + window.location.host
socket = io.connect loc

window.views = []

socket.on 'connect', () ->
  paths = window.location.pathname.split '/'
  id = paths[paths.length-1]
  socket.emit('assoc', { channel: id })

socket.on 'reload', (what) -> 
  $('.flash').append "<div class='warning'>New Code recieved, reloading...</div>"
  setTimeout ->
    window.location.reload()
  , 5000

socket.on 'data', (data) ->
  type = data.type
  dataName = data.name
  for h in window.handlerTypes
    view = $('.view')
    target = view.find("##{dataName}") 
    target = $("<div class=\"handler #{h.name}\" id=\"#{dataName}\"></div>").appendTo view unless target.length > 0
    if _.contains h.handles, data.type
      unless window.views[dataName]
        window.views[dataName] = new h(dataName)
        window.views[dataName].setup() 
      window.views[dataName].data(data)
