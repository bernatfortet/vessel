console.log "i'm the content script"

#chrome.runtime.sendMessage( {greeting: "hello"}, (response) ->
#	console.log(response.farewell);
#)


chrome.runtime.onMessage.addListener( 
	(request, sender, sendResponse)	->
		console.log 'This is the content script. link has been added'

		if( request.action == 'added_link' )
			alert('Link Added')
)