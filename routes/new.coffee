exports.new = (req, res) -> 
  res.render 'new', { title: 'ScratchLab' } 

exports.create = (req, res) ->
  name = req.body.name
  id = crypto.randomBytes(20).toString('hex');
  channels[id] = {id: id, name: name}
  res.redirect("/channels/#{id}")

exports.show = (req, res) ->
  res.render 'channel', { channel: channels[req.params.id] }
