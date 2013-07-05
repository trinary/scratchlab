express = require('express')
routes = require('./routes/')
socket = require('socket.io')
cors   = require('cors')
crypto = require('crypto')

app = module.exports = express.createServer()
io = socket.listen(app)

port = process.env.SCRATCHLAB_PORT || 3000

key = process.env.SCRATCHLAB_KEY || "example"
console.log key

types = {}
channels = {}

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

# Routes
#
app.get '/', cors(), routes.index 

app.get '/types', cors(), (req, res) ->
  res.status(200).json types

app.get  '/new', cors(), (req, res) -> 
  res.render 'new', { title: 'ScratchLab' } 
app.get '/channels/:id', cors(), (req, res) -> 
  channel = channels[req.params.id]
  res.render 'show', { title: channel.name, channel: channel.id }
app.post '/new', cors(), (req, res) ->
  name = req.body.name
  id = crypto.randomBytes(20).toString('hex')
  key= crypto.randomBytes(20).toString('hex')
  channels[id] = {id: id, name: name, key: key}
  res.redirect("/channels/#{id}")


app.post '/channels/:id/data', cors(), (req,res) ->
  unless types[req.body.type]
    types[req.body.type] = req.body
  io.sockets.emit 'data', req.body
  res.status(201).json {status: "created"}

app.post '/update', cors(), (req, res) ->
  io.sockets.emit 'reload', {target: "all"}
  res.status(200).json {status: "reloaded"}

io.sockets.on 'connection', (socket) ->
  socket.on 'new code', (data) ->
    socket.emit 'reload', {target: "all"}

app.listen port,->
  console.log "Express server listening on port %d in %s mode", 
    app.address().port, app.settings.env

