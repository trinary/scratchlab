pg      = require('pg')
pgPass  = process.env.POSTGRES_PASS || ""

conString = "tcp://scratchlab:" + pgPass + "@localhost:5432/scratchlab"
pgClient = new pg.Client(conString)
pgClient.connect()

module.exports = 
  findOrCreateUserByGhId: (gh_user, callback) ->
    pgClient.query 'select * from users where github_id = $1', [gh_user.id], (err, result) ->
      if result.rowCount == 0
        pgClient.query 'insert into users (created_at, updated_at, logged_in, github_id) values(now(), now(), now(), $1)', [gh_user.id], (err, result) ->
          pgClient.query 'select * from users where github_id = $1', [gh_user.id], (err, result) ->
            callback gh_user, result.rows[0].id
      else pgClient.query 'update users set logged_in = now() where github_id = $1', [gh_user.id], (err, result) ->
          pgClient.query 'select * from users where github_id = $1', [gh_user.id], (err, result) ->
            callback gh_user, result.rows[0].id

  findChannelById: (id, callback) ->
    pgClient.query 'select * from channels where id = $1', [id], (err,result) ->
      callback(err, result.rows)

  findChannelsByUser: (user, callback) ->
    pgClient.query 'select * from channels where user_id = $1', [user], (err, result) ->
      console.log(err,result)
      callback(err,result.rows)

  findGistsByChannel: (id, callback) ->
    pgClient.query 'select * from gists where channel_id = $1', [id], (err,result) ->
      callback(err, result.rows)

  createChannel: (id, key, name, user, callback) ->
    pgClient.query 'insert into channels (id, key, name, user_id, created_at, updated_at) values ($1, $2, $3, $4, now(), now())',[id, key, name, user], (err, result) ->
      callback(err, result.rows)

  createGist: (href, channel) ->
    pgClient.query 'insert into gists (gist_href, channel_id) values ($1, $2)', [href, channel], (err, result) ->
      callback(err,result.rows)

