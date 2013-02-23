class TimeLine

  svg: null
  points: []
  handles: ["timeline"]
  name: "timeline"
  initialized: false
  margin:
    left: 40
    right: 40
    top: 40
    bottom:40

  setup: (elem) =>
    @initialized = true
    @svg = d3.select("##{@name}")
      .append "svg"
    @svg.attr
      width: $("##{@name}").width()
      height: $("##{@name}").height()
    @lineG = @svg.append("g")
    @lineG.attr("transform","translate(#{@margin.left},#{@margin.top})")
    @path = @lineG.append("path")

    @updateScales()
    @updateAxes()

    @svg.append("g")
        .attr("class","x axis")
        .attr("transform","translate(#{@margin.left},#{@svg.attr("height") - @margin.bottom})")
        .call(@xaxis)

  updateScales: =>
    @x = d3.time.scale()
      .range([0,@svg.attr("width") - (@margin.left + @margin.right)])
      .domain(d3.extent(@points, (d) -> d.timestamp))

    @y = d3.scale.linear()
      .range([@svg.attr("height") - (@margin.top + @margin.bottom),0])
      .domain([0,d3.max(@points, (d) -> d.value)])

  updateAxes: =>
    @xaxis = d3.svg.axis()
              .scale(@x)
              .orient("bottom")

    @yaxis = d3.svg.axis()
              .scale(@y)
              .orient("left")


  data: (data, elem) =>
    @points.push data
    @points = @points.slice(@points.length - 200) if @points.length > 200
    @updateScales()
    @updateAxes()

    line = d3.svg.line()
      .x( (d) => @x d.timestamp)
      .y( (d) => @y d.value)

    @path.datum(@points)
      .attr("class","time-line")
      .attr("d",line)
      .transition()
      .duration(100)


window.handlerTypes.push TimeLine
