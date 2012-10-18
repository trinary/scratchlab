class LoadAverage

  svg: null
  points: []
  handles: ["loadavg"]
  name: "loadavg"
  margin:
    left: 40
    right: 40
    top: 40
    bottom:40

  data: (data, elem) =>
    @points.push data
    @points = @points.slice(@points.length - 200) if @points.length > 200
    if @svg == null
      @svg = d3.select("##{@name}")
        .append "svg"
      @svg.attr
        width: $("##{@name}").width()
        height: $("##{@name}").height()
      @lineG = @svg.append("g")
      @lineG.attr("transform","translate(#{@margin.left},#{@margin.top})")
      @path = @lineG.append("path")

    x = d3.time.scale()
      .range([0,@svg.attr("width") - (@margin.left + @margin.right)])
      .domain(d3.extent(@points, (d) -> d.timestamp))

    y = d3.scale.linear()
      .range([@svg.attr("height") - (@margin.top + @margin.bottom),0])
      .domain([0,d3.max(@points, (d) -> d.value)])

    line = d3.svg.line()
      .x( (d) -> x d.timestamp)
      .y( (d) -> y d.value)


    @path.datum(@points)
      .attr("class","load-avg-line")
      .attr("d",line)

window.handlerTypes.push LoadAverage
