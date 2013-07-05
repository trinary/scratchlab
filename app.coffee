express = require('express')
routes  = require('./routes/')
socket  = require('socket.io')
cors    = require('cors')
http    = require('http')
crypto  = require('crypto')
redis   = require('redis')

rClient = redis.createClient()


port = process.env.SCRATCHLAB_PORT || 3000

app = express()
server = http.createServer(app)
io = socket.listen(server)

types = {}
clients = {}

# Configuration

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.static(__dirname + '/public')
  app.use require('connect-assets')()

app.configure 'development', ->
  app.use express.errorHandler { dumpExceptions: true, showStack: true }

app.configure 'production', ->
  app.use express.errorHandler()

app.use app.router

# Routes
#
app.get '/', cors(), routes.index 

app.get '/types', cors(), (req, res) ->
  res.status(200).json types

app.get  '/new', cors(), (req, res) -> 
  res.render 'new', { title: 'ScratchLab' } 

app.get '/channels/:id', cors(), (req, res) -> 
  channel = rClient.get req.params.id, (e, d) ->
    if (! channel)
      res.send(404, "Sorry, channel not found")
    else
      channel = JSON.parse(d)
      console.log "hello",channel
      res.render 'show', { title: channel.name, channel: channel }

app.post '/new', cors(), (req, res) ->
  name = req.body.name
  id = crypto.randomBytes(20).toString('hex')
  key= crypto.randomBytes(10).toString('hex')
  rClient.set(id, JSON.stringify({id: id, name: name, key: key}))
  res.redirect("/channels/#{id}")

app.post '/channels/:id/data', cors(), (req,res) ->
  channel = rClient.get(req.params.id)
  if (! channel)
    res.send(404, "Sorry, channel not found")
  else
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
  socket.on 'assoc', (data) ->
    console.log "ASSOC",data
    clients[data.channel] = 'asdf'

server.listen(port)
