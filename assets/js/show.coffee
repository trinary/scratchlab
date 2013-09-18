showViews = () ->
  viewContainer = d3.select("ul.view-container")
  viewContainer.selectAll(".view-type").data(window.handlerTypes)
    .enter()
    .append("li")
    .classed("view-type",true)
    .text (d,i) -> d.name

getGists = () ->
  gistsUrl = window.location + "/gists"
  d3.json gistsUrl, (e, d) -> 
    d3.select("ul.gists").selectAll(".gist").data(d.gists).enter()
      .append("li")
      .classed("gist", true)
      .text (data) -> data.gist_href
    for gist in d.gists
      id = gist.gist_href.split('/').pop()
      apiUrl = "https://api.github.com/gists/#{id}"
      d3.json apiUrl, (e, d) ->
        for file of d.files
          body = d3.select("body")
          if d.files[file]["type"] == "application/javascript"
            body.append("script")
              .attr("id", id)
              .attr("type", "text/javascript")
              .text( d.files[file]["content"])
        showViews()

  d3.select("#add_gist").on "click", (e) ->
    url = document.getElementById("gist_input").value
    obj = { gist_href: url }
    $.post(window.location + "/gists", obj, (d, s, xhr) ->
      getGists()
    , "application/json")

toggleInfo = (ev) ->
  info = d3.select(".infobox")
  info.classed("hidden", ! info.classed("hidden"))


window.views = []
d3.select(".infobutton").on("click", toggleInfo)
d3.select(".infox").on("click", toggleInfo)
getGists()
