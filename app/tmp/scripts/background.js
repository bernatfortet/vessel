(function() {
  var App, app;

  console.log("I'm in the background");

  App = (function() {
    function App() {
      console.log('Hello World');
      this.connectToMeteor();
    }

    App.prototype.connectToMeteor = function() {
      var options;
      options = {
        endpoint: "ws://localhost:3000/websocket",
        SocketConstructor: WebSocket
      };
      this.ddp = new DDP(options);
      return this.ddp.on('connected', function() {
        return console.log('Connected');
      });
    };

    App.prototype.sendLink = function(link_title, fav_icon_url, link_url) {
      var linkData;
      linkData = {
        link_title: link_title,
        fav_icon_url: fav_icon_url,
        link_url: link_url
      };
      this.ddp.method('addLink', [linkData]);
      return console.log('sending links');
    };

    return App;

  })();

  app = new App();

  chrome.browserAction.onClicked.addListener(function(tab) {
    console.log('browserAction Clicked', tab);
    return app.sendLink(tab.title, tab.favIconUrl, tab.url);
  });

  /*
  chrome.tabs.getSelected( null, (tab) -> 
  	console.log 'test', tab
  )
  
  
  chrome.runtime.sendMessage( {greeting: "hello"}, (response) ->
  	console.log(response.farewell);
  )
  
  
  
  chrome.runtime.onMessage.addListener( 
  	(request, sender, sendResponse)	->
  		console.log( if sender.tab then "from a content script:" + sender.tab.url else "from the extension")
  
  		if (request.greeting == "hello")
  			sendResponse({farewell: "goodbye"});
  )
  */


}).call(this);
