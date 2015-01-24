console.log "i'm the content script"

chrome.runtime.sendMessage( {greeting: "hello"}, (response) ->
	console.log(response.farewell);
)


chrome.runtime.onMessage.addListener( 
	(request, sender, sendResponse)	->
		console.log( if sender.tab then "from a content script:" + sender.tab.url else "from the extension")

		if (request.greeting == "hello")
			sendResponse({farewell: "goodbye"});
)