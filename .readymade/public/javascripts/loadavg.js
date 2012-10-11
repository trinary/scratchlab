(function() {
  var LoadAverage;

  LoadAverage = (function() {

    function LoadAverage() {}

    LoadAverage.prototype.data = function(data, elem) {
      return elem.append($("<p class='load'>" + data.value + "</p>"));
    };

    LoadAverage.prototype.handles = ["loadavg"];

    LoadAverage.prototype.name = "loadavg";

    return LoadAverage;

  })();

  window.handlerTypes.push(LoadAverage);

}).call(this);
