(function() {
  var BasicText;

  BasicText = (function() {

    function BasicText() {}

    BasicText.prototype.data = function(data, elem) {
      return elem.append($("<p class='text'>" + data.content + "</p>"));
    };

    BasicText.prototype.handles = ["text"];

    BasicText.prototype.name = "basictext";

    return BasicText;

  })();

  window.handlerTypes.push(BasicText);

}).call(this);
