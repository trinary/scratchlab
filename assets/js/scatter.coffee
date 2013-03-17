class Scatter
  @handles: ["scatter"]
  svg: null
  points: null
  type: "scatter"
  name: ""
  initialized: false
  margin:
    left: 60
    right: 40
    top: 40
    bottom:40

  constructor: (name) ->
    @name = name

  setup: () ->
    @initialized = true
    @svg = d3.select("##{@name}")
      .append "svg"
    @svg.attr
      width: $("##{@name}").width()
      height: $("##{@name}").height()

    @lineG = @svg.append("g")
    @lineG.attr("transform","translate(#{@margin.left},#{@margin.top})")

    @g = @lineG.append("g")
      .data(@points)
      .attr("class","scatter")

  updateScales: ->
    @x = d3.scale.linear()
      .range([0,@svg.attr("width") - (@margin.left + @margin.right)])
      .domain(d3.extent(@points, (d) -> d.x))

    @y = d3.scale.linear()
      .range([@svg.attr("height") - (@margin.top + @margin.bottom),0])
      .domain([0,d3.max(@points, (d) -> d.y)])

  updateAxes: ->
    @xaxis = d3.svg.axis()
              .scale(@x)
              .orient("bottom")

    @yaxis = d3.svg.axis()
              .scale(@y)
              .orient("left")
              .tickFormat(d3.format('0.2s'))

  clearAxes: ->
    @clearXAxis()
    @clearYAxis()

  drawAxes: ->
    @drawXAxis()
    @drawYAxis()

  clearXAxis: ->
    @svg.select(".x.axis").remove()

  clearYAxis: ->
    @svg.select(".y.axis").remove()

  drawXAxis: ->
    @svg.append("g")
        .attr("class","x axis")
        .attr("transform","translate(#{@margin.left},#{@svg.attr("height") - @margin.bottom})")
        .call(@xaxis)

  drawYAxis: ->
    @svg.append("g")
        .attr("class","y axis")
        .attr("transform","translate(#{@margin.left},#{@margin.top})")
        .call(@yaxis)


  data: (data) ->
    @points = new Array if @points == null
    @points.push data
    if @points.length > 500
      @points = @points.slice(-500)

    @clearAxes()
    @updateScales()
    @updateAxes()
    @drawAxes()

    @svg.selectAll(".scatter")
      .data(@points)
      .enter()
      .append("circle")
      .attr("cx", (d) => d.x)
      .attr("cy", (d) => d.y)
      .attr("r", 5)

window.handlerTypes.push Scatter
