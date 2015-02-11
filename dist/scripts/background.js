(function() {
  var App, app;

  console.log("I'm in the background");

  App = (function() {
    App.prototype.userId = null;

    function App() {
      /*
      		chrome.storage.sync.set
      			'value': theValue
      		, ->
      			# Notify that we saved.
      			message 'Settings saved'
      			return
      
      		chrome.storage.sync.get 'value' , (items) ->
      			console.log 'Items', items
      			return
      */

      this.connectToMeteor();
    }

    App.prototype.connectToMeteor = function() {
      var _this = this;
      this.ddp = new Asteroid("localhost:3000");
      this.ddp.on('connected', function() {
        console.log('Connected');
        return _this.ddp.resumeLoginPromise.then(function() {
          return console.log('ok');
        }).fail(function() {
          console.log('fail, now log in');
          return _this.ddp.subscribe("meteor.loginServiceConfiguration").ready.then(function() {
            return _this.ddp.loginWithTwitter();
          });
        });
      });
      return this.ddp.on('login', function(loggedInUserId) {
        console.log('Logged, userId:', loggedInUserId);
        return _this.userId = loggedInUserId;
      });
    };

    App.prototype.sendLink = function(link_title, fav_icon_url, link_url) {
      var linkData;
      console.log(this.userId);
      linkData = {
        link_title: link_title,
        fav_icon_url: fav_icon_url,
        link_url: link_url,
        owner: this.userId
      };
      this.ddp.call('addLink', linkData);
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
