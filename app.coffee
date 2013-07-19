express = require('express')
routes  = require('./routes/')
socket  = require('socket.io')
cors    = require('cors')
http    = require('http')
request = require('request')
crypto  = require('crypto')
redis   = require('redis')

rClient = redis.createClient()


port = process.env.SCRATCHLAB_PORT || 3000
secret = process.env.SESSION_SECRET || crypto.randomBytes(12).toString('hex')
githubSecret = process.env.GITHUB_SECRET || ""
githubId = process.env.GITHUB_ID || "7a56e86c888d930f9d40"

app = express()
server = http.createServer(app)
io = socket.listen(server)

types = {}

# Configuration

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use express.cookieSession({secret: secret})
  app.use express.session({secret: secret})

  app.use express.methodOverride()
  app.use express.static(__dirname + '/public')
  app.use require('connect-assets')()

app.configure 'development', ->
  app.use express.errorHandler { dumpExceptions: true, showStack: true }

app.configure 'production', ->
  app.use express.errorHandler()

app.use app.router

# Middleware
#
trueAuth = express.basicAuth (user, pass) -> true
# Routes
#
app.get '/', cors(), (req, res) -> 
  console.log req.session.user
  res.render 'index', {title: 'ScratchLab', session: req.session }

app.get '/types', cors(), (req, res) ->
  res.status(200).json types

app.get  '/new', cors(), (req, res) -> 
  res.render 'new', { title: 'ScratchLab', session: req.session }

app.get '/channels/:id', cors(), (req, res) -> 
  console.log "getting #{req.params.id}"
  rClient.hgetall req.params.id, (e, d) ->
    channel = d
    if (! channel)
      res.send(404, "Sorry, channel not found")
    else
      res.render 'show', { title: channel.name, channel: channel, session: req.session }

app.get '/login', (req, res) ->
  ghUrl = "https://github.com/login/oauth/authorize?redirect_uri=http://scratchlab.io/auth&scope=gist&client_id=" + githubId 
  res.redirect(ghUrl)

app.get '/auth', (req, res) ->
  code = req.query.code
  console.log code
  request
    url: "https://github.com/login/oauth/access_token",
    method: "POST",
    headers:
      accept: "application/json"
    form:
      client_id: githubId,
      client_secret: githubSecret,
      code: code
  , (e, r, body ) ->
    console.log body
    req.session["token"] = JSON.parse(body).access_token
    request
      url: "https://api.github.com/user?access_token=" + req.session["token"]
      headers:
        accept: "application/json"
    , (e, r, body) ->
      user = JSON.parse(body)
      console.log body, user
      req.session["login"] = user.login
      req.session["avatar"] = user.avatar_url
      req.session["gh_id"] = user.id
      res.redirect "/" 

app.post '/new', (req, res) ->
  name = req.body.name
  id = crypto.randomBytes(12).toString('hex')
  key= crypto.randomBytes(8).toString('hex')
  user=req.session["gh_id"]
  console.log user
  rClient.hmset(id,{name: name, key: key, user: user})
  rClient.lpush(user, id)
  res.redirect("/channels/#{id}")

app.get '/channels', (req, res) -> 
  if req.session["gh_id"]
    console.log req.session["gh_id"]
    rClient.lrange req.session["gh_id"], 0, -1, (e,d) ->
      console.log e, d
      if d
        console.log d
        rClient.mget d, (e2,d2) ->
          console.log d2
          res.render 'channels', {title: "Channels", session: req.session, channels: d2}
      else
        res.render 'channels', {title: "Channels", session: req.session, channels: [] }
  else
    res.render 'channels', {title: "Channels", session: req.session, channels: [] }


app.post '/channels/:id/data', trueAuth, (req,res) ->
  room = req.params.id
  rClient.get req.params.id, (e,d) ->
    channel = JSON.parse d
    if (! channel)
      res.send(404, "Sorry, channel not found")
    else
      if (req.user != channel.key)
        return res.status(403).json { status: "unauthorized"}
      unless types[req.body.type]
        types[req.body.type] = req.body
      io.sockets.in(room).emit('data', req.body)
      res.status(201).json {status: "created"}

io.sockets.on 'connection', (socket) ->
  socket.on 'new code', (data) ->
    socket.emit 'reload', {target: "all"}
  socket.on 'assoc', (data) ->
    socket.join data.channel

server.listen(port)
