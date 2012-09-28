express = require('express')
routes = require('./routes')
socket = require('socket.io')

app = module.exports = express.createServer()
io = socket.listen(app)

# Configuration

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(__dirname + '/public')
  app.use require('readymade').middleware(root: 'public')

app.configure 'development', ->
  app.use express.errorHandler { dumpExceptions: true, showStack: true }

app.configure 'production', ->
  app.use express.errorHandler()

# Routes

app.get '/', routes.index 

io.sockets.on 'connection', (socket) ->
  socket.emit 'news', { hello: 'world' }
  socket.on 'my other event', (data) ->
    console.log(data)
  socket.on 'new code', (data) ->
    socket.emit 'reload', {target: "all"}

app.listen 3000,->
  console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env

