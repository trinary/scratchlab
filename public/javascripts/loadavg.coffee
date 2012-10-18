class LoadAverage

  svg: null
  points: []
  handles: ["loadavg"]
  name: "loadavg"

  data: (data, elem) =>
    @points.push data
    @points = @points.slice(@points.length - 200) if @points.length > 200
    if @svg == null
      @svg = d3.select("##{@name}")
        .append "svg"
      @svg.attr
        width: elem.width()
        height: elem.height()
      @lineG = @svg.append("g")
      @path = @lineG.append("path")

    x = d3.time.scale()
      .range([0,@svg.attr("width")])
      .domain(d3.extent(@points, (d) -> d.timestamp))

    y = d3.scale.linear()
      .range([@svg.attr("height"),0])
      .domain([0,d3.max(@points, (d) -> d.value)])

    line = d3.svg.line()
      .x( (d) -> x d.timestamp)
      .y( (d) -> y d.value)


    @path.datum(@points)
      .attr("class","load-avg-line")
      .attr("d",line)

window.handlerTypes.push LoadAverage
