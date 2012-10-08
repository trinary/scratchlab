(function() {
  var LoadAverage;

  LoadAverage = (function() {

    function LoadAverage() {}

    LoadAverage.prototype.data = function(data, elem) {
      return elem.append(data.value);
    };

    LoadAverage.prototype.handles = ["loadavg"];

    return LoadAverage;

  })();

  if (window.handlerTypes) {
    window.handlerTypes.push(LoadAverage);
  } else {
    window.handlerTypes = [LoadAverage];
  }

}).call(this);
