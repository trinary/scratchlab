(function() {
  var BasicText;

  BasicText = (function() {

    function BasicText() {}

    BasicText.prototype.data = function(data, elem) {
      return elem.append(data.content);
    };

    BasicText.prototype.handles = ["text"];

    return BasicText;

  })();

  if (window.handlers) {
    window.handlerTypes.push(BasicText);
  } else {
    window.handlerTypes = [BasicText];
  }

}).call(this);
