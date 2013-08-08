getGists = () ->
  gistsUrl = window.location + "/gists"
  d3.json gistsUrl, (e, d) -> 
    for gist in d.gists
      id = gist.gist_href.split('/').pop()
      apiUrl = "https://api.github.com/gists/#{id}"
      d3.json apiUrl, (e, d) ->
        for file of d.files
          body = d3.select("body")
          body.append("script")
            .attr("type", "text/javascript")
            .text( d.files[file]["content"])
          window.showViews()

getGists()
