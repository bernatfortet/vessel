console.log "I'm in the background"

class App
	constructor: ->

		console.log 'Hello World'
		this.connectToMeteor()


	connectToMeteor: ->

		options = 
			endpoint: "ws://localhost:3000/websocket"
			SocketConstructor: WebSocket

		this.ddp = new DDP(options);

		this.ddp.on('connected', ->
			console.log 'Connected'
		)

	sendLink: (link_title, fav_icon_url, link_url) ->
		linkData = 
			link_title: link_title,
			fav_icon_url: fav_icon_url,
			link_url: link_url,

		this.ddp.method('addLink', [linkData])
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

