express = require('express')
routes  = require('./routes/')
socket  = require('socket.io')
cors    = require('cors')
http    = require('http')
request = require('request')
crypto  = require('crypto')
pg      = require('pg')

port = process.env.SCRATCHLAB_PORT || 3000
secret = process.env.SESSION_SECRET || "razzledazzlerootbeer"
githubSecret = process.env.GITHUB_SECRET || ""
githubId = process.env.GITHUB_ID || "7a56e86c888d930f9d40"
pgPass = process.env.POSTGRES_PASS || ""

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

conString = "tcp://scratchlab:" + pgPass + "@localhost:5432/scratchlab"
pgClient = new pg.Client(conString)
# Middleware
#
trueAuth = express.basicAuth (user, pass) -> true
# Routes
#
app.get '/', cors(), (req, res) -> 
  res.render 'index', {title: 'ScratchLab', session: req.session }

app.get '/types', cors(), (req, res) ->
  res.status(200).json types

app.get  '/new', cors(), (req, res) -> 
  res.render 'new', { title: 'ScratchLab', session: req.session }

app.get '/channels/:id', cors(), (req, res) -> 
  pgClient.connect (err) ->
    if err
      console.error 'could not connect to postgres', err
      res.send 500, "Error connecting to the database"
    else
      pgClient.query 'select * from channels where id = $1',[req.params.id], (err, result) ->
        channel = result[0]
        if (! channel)
          res.send 404, "Sorry, channel not found"
        else
          res.render 'show', { title: channel.name, channel: channel, session: req.session }
    pgClient.end()

app.get '/login', (req, res) ->
  ghUrl = "https://github.com/login/oauth/authorize?redirect_uri=http://scratchlab.io/auth&scope=gist&client_id=" + githubId 
  res.redirect(ghUrl)

app.get '/auth', (req, res) ->
  code = req.query.code
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
    req.session["token"] = JSON.parse(body).access_token
    request
      url: "https://api.github.com/user?access_token=" + req.session["token"]
      headers:
        accept: "application/json"
    , (e, r, body) ->
      user = JSON.parse(body)
      pgClient.connect (err) ->
        if err
          console.error 'could not connect to postgres', err
          res.send 500, "Error connecting to the database"
        else
          pgClient.query 'select * from users where github_id = $1', [user.id], (err, result) ->
            if result? 
              pgClient.query 'insert into users(created_at, updated_at, logged_in, github_id) values(now(), now, now(), $1', user.id, (err, result) ->
                console.log "success?"
            else pgClient.query 'update users set logged_in = now() where github_id = $1', [user.id], (err, result) ->
                console.log "update success?"
            req.session["login"] = user.login
            req.session["avatar"] = user.avatar_url
            req.session["gh_id"] = user.id
            res.redirect "/" 
        pgClient.end()

app.post '/new', (req, res) ->
  name = req.body.name
  id = crypto.randomBytes(12).toString('hex')
  key= crypto.randomBytes(8).toString('hex')
  user=req.session["gh_id"]
  obj = {name: name, key: key, user: user}
  pgClient.connect (err) ->
    if err
      console.error 'could not connect to postgres', err
      res.send 500, "Error connecting to the database"
    else
      pgClient.query 'insert into channels (id, key, name, created_at, updated_at) values ($1, $2, $3, now(), now()',[id, key, name], (err, result) ->
        console.log("hooray")
    pgClient.end()
  res.redirect("/channels/#{id}")

app.get '/channels', (req, res) -> 
  if req.session["gh_id"]
    pgClient.connect (err) ->
      if err
        console.error 'could not connect to postgres', err
        res.send 500, "Error connecting to the database"
      else
        pgClient.query 'select * from channels where github_id = $1', [req.session["gh_id"]], (err, result) ->
          channels = result
          res.render 'channels', {title: "Channels", session: req.session, channels: d2}
      pgClient.end()





app.post '/channels/:id/data', trueAuth, (req,res) ->
  room = req.params.id
  pgClient.connect (err) ->
    if err
      console.error 'could not connect to postgres', err
      res.send 500, "Error connecting to the database"
    else
      pgClient.query 'select * from channels where id = $1', [room], (err, result) ->
      channel = result[0]
      console.log channel
      if (! channel)
        res.send(404, "Sorry, channel not found")
      else
        if (req.user != channel.key)
          return res.status(403).json { status: "unauthorized"}
        unless types[req.body.type]
          types[req.body.type] = req.body
        io.sockets.in(room).emit('data', req.body)
        res.status(201).json {status: "created"}
    pgClient.end()

io.sockets.on 'connection', (socket) ->
  socket.on 'new code', (data) ->
    socket.emit 'reload', {target: "all"}
  socket.on 'assoc', (data) ->
    socket.join data.channel

server.listen(port)
