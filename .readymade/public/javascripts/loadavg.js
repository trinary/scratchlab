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

  if ((window.handlerTypes != null) > 0) {
    window.handlerTypes.push(LoadAverage);
  } else {
    window.handlerTypes = [LoadAverage];
  }

}).call(this);
