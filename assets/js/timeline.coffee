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

    @updateScales()
    @updateAxes()

    @lineG = @svg.append("g")
    @lineG.attr("transform","translate(#{@margin.left},#{@margin.top})")


    @path = @lineG.append("path")
      .data([@points])
      .attr("class","time-line")

  updateScales: =>
    @x = d3.time.scale()
      .range([0,@svg.attr("width") - (@margin.left + @margin.right)])
      .domain(d3.extent(@points, (d) -> d.timestamp))

    console.log d3.extent(@points, (d) -> d.timestamp)

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

  clearAxes: =>
    @clearXAxis()
    @clearYAxis()

  drawAxes: =>
    @drawXAxis()
    @drawYAxis()

  clearXAxis: =>
    @svg.select(".x.axis").remove()

  clearYAxis: =>
    @svg.select(".y.axis").remove()

  drawXAxis: =>
    @svg.append("g")
        .attr("class","x axis")
        .attr("transform","translate(#{@margin.left},#{@svg.attr("height") - @margin.bottom})")
        .call(@xaxis)

  drawYAxis: =>
    @svg.append("g")
        .attr("class","y axis")
        .attr("transform","translate(#{@margin.left},#{@margin.top})")
        .call(@yaxis)

  updateLine: =>
    @line = d3.svg.line()
      .x( (d) => @x d.timestamp)
      .y( (d) => @y d.value)

  data: (data, elem) =>
    @points.push data
    if @points.length > 20
      console.log "Slicing, length = #{@points.length}"
      @points = @points.slice(-20)
      console.log @points

    @clearAxes()
    @updateScales()
    @updateAxes()
    @drawAxes()
    @updateLine()

    @path.attr("d", @line)

    console.log @line(@points)


window.handlerTypes.push TimeLine
