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

  console.log("adding text");

  window.handlerTypes.push(BasicText);

}).call(this);
