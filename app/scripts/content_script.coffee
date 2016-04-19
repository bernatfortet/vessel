console.log "i'm the content script"

#chrome.runtime.sendMessage( {greeting: "hello"}, (response) ->
#	console.log(response.farewell);
#)


chrome.runtime.onMessage.addListener( 
	(request, sender, sendResponse)	->
		console.log 'This is the content script. link has been added'

		

		if( request.action == 'added_link' )

			html = '
				<div id="vesselOverlay" style="width:100%; height:100%; position:fixed; left:0; top:0; background-color:#42E483; z-index:999999;">
					<div style="margin-top:140px; font-size:36px; color:rgba(0,0,0,0.8); font-weight:bold; text-align:center;">Saved</div>
					<div style="margin-top:24px; font-size:18px; color:rgba(0,0,0,0.6); text-align:center;">Next digest will be sent at 8 PM</div>
				</div>
			'
			$('body').append(html)
			pop = $('#vesselOverlay')

			$.Velocity.hook( pop, "scale", '0')

			pop.velocity({ scale: 1 }, { duration: 800, easing: [ 250, 15 ] } )
			

		#	alert('Link Added')
)


chrome.extension.sendRequest({redirect: "http://localhost:3000"});