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

      var userEmail;
      if (localStorage['email'] === null) {
        userEmail = prompt("Please enter your email");
        localStorage["email"] = userEmail;
      }
      this.connectToMeteor();
    }

    App.prototype.connectToMeteor = function() {
      var _this = this;
      this.ddp = new Asteroid("localhost:3000");
      this.ddp.on('connected', function() {
        return console.log('Connected');
        /*
        			this.ddp.resumeLoginPromise.then( ->
        				console.log ('ok')
        			).fail( =>
        				console.log 'fail, now log in'
        
        				#this.ddp.subscribe("meteor.loginServiceConfiguration").ready.then =>
        				#	this.ddp.loginWithTwitter()
        					#this.ddp.loginWithFacebook()
        			)
        */

      });
      return this.ddp.on('login', function(loggedInUserId) {
        console.log('Logged, userId:', loggedInUserId);
        return _this.userId = loggedInUserId;
      });
    };

    App.prototype.sendLink = function(link_title, fav_icon_url, link_url) {
      var linkData;
      if ((localStorage['email'] != null)) {
        linkData = {
          link_title: link_title,
          fav_icon_url: fav_icon_url,
          link_url: link_url,
          owner: this.userId,
          ownerEmail: localStorage['email']
        };
        this.ddp.call('addLink', linkData);
        return console.log('Sending Link to', linkData.ownerEmail);
      } else {
        return app.authenticateUser();
      }
    };

    App.prototype.authenticateUser = function() {
      return chrome.tabs.create({
        url: 'http://localhost:3000'
      });
    };

    App.prototype.setUserEmailOnLocalStorage = function(email) {
      localStorage["email"] = email;
      return console.log('Extension now will send emails to ', email);
    };

    return App;

  })();

  app = new App();

  chrome.browserAction.onClicked.addListener(function(tab) {
    console.log('browserAction Clicked', tab);
    app.sendLink(tab.title, tab.favIconUrl, tab.url);
    return chrome.tabs.sendMessage(tab.id, {
      action: "added_link",
      tab: tab
    }, function(response) {
      return console.log(response);
    });
  });

  chrome.runtime.onMessageExternal.addListener(function(request, sender, sendResponse) {
    console.log(request, sender, sendResponse);
    if ((request.userEmail != null)) {
      app.setUserEmailOnLocalStorage(request.userEmail);
    }
    return console.log('Hello');
  });

  /*
  
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
