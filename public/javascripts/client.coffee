$ ->
  socket = io.connect 'http://localhost'
  socket.on 'reload', (what) -> 
    console.log what 
    $('.flash').append "<div class='warning'>New Code recieved, reloading...</div>"
    setTimeout ->
      window.location.reload()
    , 5000
  socket.on 'data', (data) ->
    console.log "Got new data", data
