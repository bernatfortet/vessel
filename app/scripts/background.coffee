console.log "I'm in the background"

class App
	userId: null
	constructor: ->

		###
		chrome.storage.sync.set
			'value': theValue
		, ->
			# Notify that we saved.
			message 'Settings saved'
			return

		chrome.storage.sync.get 'value' , (items) ->
			console.log 'Items', items
			return
		###	

		if( localStorage['email'] == null )
			userEmail = prompt("Please enter your email")
			localStorage["email"] = userEmail

		#userEmail = 'bernatfortet@gmail.com'
		#chrome.storage.sync.set { 'email': userEmail }, ->
			# Notify that we saved.
			#message 'Settings saved'
		#	return


		this.connectToMeteor()


	connectToMeteor: ->
		#this.ddp = new Asteroid("vesselapp.meteor.com");
		this.ddp = new Asteroid("localhost:3000");


		this.ddp.on('connected', =>
			console.log 'Connected'

			###
			this.ddp.resumeLoginPromise.then( ->
				console.log ('ok')
			).fail( =>
				console.log 'fail, now log in'

				#this.ddp.subscribe("meteor.loginServiceConfiguration").ready.then =>
				#	this.ddp.loginWithTwitter()
					#this.ddp.loginWithFacebook()
			)
			###

		)

		this.ddp.on('login', (loggedInUserId) =>
			console.log 'Logged, userId:', loggedInUserId
			this.userId = loggedInUserId
		)

	sendLink: (link_title, fav_icon_url, link_url) ->

		if( localStorage['email']? )
			linkData = 
				link_title: link_title
				fav_icon_url: fav_icon_url
				link_url: link_url
				owner: this.userId
				ownerEmail: localStorage['email']

			this.ddp.call('addLink', linkData)
			console.log 'Sending Link to', linkData.ownerEmail
		else
			app.authenticateUser()

	authenticateUser: ->
		#chrome.extension.sendMessage({redirect: "http://localhost:3000"});
		# chrome.tabs.getCurrent(null, (tab) ->
		# 	console.log 'asdfasdfasfd'
		# 	chrome.tabs.update(tab.id, {url: 'http://localhost:3000'});
		# )

		# chrome.tabs.getSelected(null, (tab) ->
		# 	tablink = tab.url
		# 	chrome.tabs.update(tab.id, {url: 'http://localhost:3000'});
		# )

		chrome.tabs.create({ url: 'http://localhost:3000' });

	setUserEmailOnLocalStorage: (email) ->

		localStorage["email"] = email
		console.log 'Extension now will send emails to ', email



app = new App()


chrome.browserAction.onClicked.addListener( (tab) ->
	console.log 'browserAction Clicked', tab
	app.sendLink(tab.title, tab.favIconUrl, tab.url)

	#chrome.runtime.sendMessage( {greeting: "hello"}, (response) ->
	#	console.log(response.farewell);
	#)
	chrome.tabs.sendMessage( tab.id, {action: "added_link", tab: tab }, (response) ->
		console.log response
	)

)

chrome.runtime.onMessageExternal.addListener (request, sender, sendResponse) ->
	console.log request, sender, sendResponse


	if( request.userEmail? )
		app.setUserEmailOnLocalStorage( request.userEmail )
	console.log 'Hello'


###

chrome.runtime.sendMessage( {greeting: "hello"}, (response) ->
	console.log(response.farewell);
)



chrome.runtime.onMessage.addListener( 
	(request, sender, sendResponse)	->
		console.log( if sender.tab then "from a content script:" + sender.tab.url else "from the extension")

		if (request.greeting == "hello")
			sendResponse({farewell: "goodbye"});
)

###

