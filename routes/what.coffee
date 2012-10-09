exports.what = (req, res) ->
  console.log "what"
  res.render 'what', { title: 'What is ScratchLab' } 
