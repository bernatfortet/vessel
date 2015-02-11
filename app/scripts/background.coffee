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


		this.connectToMeteor()


	connectToMeteor: ->
		#this.ddp = new Asteroid("vesselapp.meteor.com");
		this.ddp = new Asteroid("localhost:3000");


		this.ddp.on('connected', =>
			console.log 'Connected'


			this.ddp.resumeLoginPromise.then( ->
				console.log ('ok')
			).fail( =>
				console.log 'fail, now log in'

				this.ddp.subscribe("meteor.loginServiceConfiguration").ready.then =>
					this.ddp.loginWithTwitter()
					#this.ddp.loginWithFacebook()
			)
		)

		this.ddp.on('login', (loggedInUserId) =>
			console.log 'Logged, userId:', loggedInUserId
			this.userId = loggedInUserId
		)

	sendLink: (link_title, fav_icon_url, link_url) ->
		console.log this.userId
		linkData = 
			link_title: link_title
			fav_icon_url: fav_icon_url
			link_url: link_url
			owner: this.userId

		this.ddp.call('addLink', linkData)
		console.log 'sending links'




app = new App()





chrome.browserAction.onClicked.addListener( (tab) ->
	console.log 'browserAction Clicked', tab
	app.sendLink(tab.title, tab.favIconUrl, tab.url)
)

###
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

###

