(function() {

  $(function() {
    var socket, t, _i, _len, _ref;
    socket = io.connect(window.location);
    window.handlers = [];
    _ref = window.handlerTypes;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      t = _ref[_i];
      window.handlers.push(new t);
    }
    socket.on('reload', function(what) {
      $('.flash').append("<div class='warning'>New Code recieved, reloading...</div>");
      return setTimeout(function() {
        return window.location.reload();
      }, 5000);
    });
    return socket.on('data', function(data) {
      var h, type, _j, _len2, _ref2, _results;
      type = data.type;
      _ref2 = window.handlers;
      _results = [];
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        h = _ref2[_j];
        if (_.contains(h.handles, data.type)) {
          _results.push(h.data(data, $('.view')));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    });
  });

}).call(this);
