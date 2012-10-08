(function() {
  var BasicText;

  BasicText = (function() {

    function BasicText() {}

    BasicText.prototype.data = function(data, elem) {
      return elem.append($("<p>" + data.content + "</p>"));
    };

    BasicText.prototype.handles = ["text"];

    return BasicText;

  })();

  if ((window.handlerTypes != null) > 0) {
    window.handlerTypes.push(BasicText);
  } else {
    window.handlerTypes = [BasicText];
  }

}).call(this);
