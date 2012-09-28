$ ->
  socket = io.connect 'http://localhost'
  socket.on 'reload', (data) -> 
    console.log data 
    $('.flash').append "<div class='warning'>New Code recieved, reloading...</div>"
    setTimeout ->
      window.location.reload()
    , 5000
