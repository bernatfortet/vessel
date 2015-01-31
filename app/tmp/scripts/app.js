(function() {
  var App;

  App = (function() {
    function App() {
      var data;
      data = {
        name: "bernat"
      };
      $('body').append(this.getTemplate('Template', data));
    }

    App.prototype.connectToMeteor = function() {
      var ddp, options;
      options = {
        endpoint: "ws://localhost:3000/websocket",
        SocketConstructor: WebSocket
      };
      ddp = new DDP(options);
      return ddp.on('connected', function() {
        var onError, onReady, onStop;
        console.log('Connected');
        ddp.method('addLink', ['bernatfortet']);
        ddp.on('added', function(data) {});
        onReady = function() {
          return console.log('onReady');
        };
        onStop = function() {
          return console.log('onStop');
        };
        onError = function() {
          return console.log('onError');
        };
        return ddp.sub("links", [""], onReady, onStop, onError(function() {}));
      });
    };

    App.prototype.getTemplate = function(templateName, data) {
      var source, template;
      source = $("#" + templateName).html();
      template = Handlebars.compile(source);
      if (data !== '') {
        return $(template(data));
      } else {
        return $(template());
      }
    };

    return App;

  })();

  $(document).ready(function() {
    var app;
    app = new App();
    return chrome.tabs.getSelected(null, function(tab) {
      return console.log('test', tab);
    });
  });

}).call(this);
