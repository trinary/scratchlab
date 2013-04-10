express = require('express')
routes = require('./routes')
socket = require('socket.io')

app = module.exports = express.createServer()
io = socket.listen(app)

port = process.env.SCRATCHLAB_PORT || 3000

key = process.env.SCRATCHLAB_KEY || "example"
console.log key

types = {}

# Configuration

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(__dirname + '/public')
  app.use require('connect-assets')()

app.configure 'development', ->
  app.use express.errorHandler { dumpExceptions: true, showStack: true }

app.configure 'production', ->
  app.use express.errorHandler()


if key
  auth = express.basicAuth (user, pass) -> 
    !key || key == user
else
  auth = express.basicAuth (user, pass) -> true
# Routes
dataPost = (req,res) ->
  unless types[req.body.type]
    types[req.body.type] = req.body
  io.sockets.emit 'data', req.body
  res.status(201).json({status: "created"})

updatePost = (req, res) ->
  io.sockets.emit 'reload', {target: "all"}
  res.status(200).json({status: "reloaded"})

app.get '/', routes.index 

app.get '/types', (req, res) ->
  res.status(200).json types

if key
  app.post '/data', auth, dataPost
  app.post '/update', auth, updatePost
else
  app.post '/data', dataPost
  app.post '/update', updatePost

io.sockets.on 'connection', (socket) ->
  socket.on 'new code', (data) ->
    socket.emit 'reload', {target: "all"}

app.listen port,->
  console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env

