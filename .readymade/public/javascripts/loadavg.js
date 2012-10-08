(function() {
  var LoadAverage;

  LoadAverage = (function() {

    function LoadAverage() {}

    LoadAverage.prototype.data = function(data, elem) {
      return elem.append($("<p>" + data.value + "</p>"));
    };

    LoadAverage.prototype.handles = ["loadavg"];

    return LoadAverage;

  })();

  console.log("adding loadavg");

  window.handlerTypes.push(LoadAverage);

}).call(this);
