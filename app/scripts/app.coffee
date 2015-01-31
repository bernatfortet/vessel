class App
	constructor: ->

		#console.log 'Hello World'
		#this.connectToMeteor()



		data =
			name: "bernat"

		$('body').append( this.getTemplate('Template', data) )



	connectToMeteor: ->

		options = 
			endpoint: "ws://localhost:3000/websocket"
			SocketConstructor: WebSocket

		ddp = new DDP(options);

		ddp.on('connected', ->
			console.log 'Connected'



			ddp.method('addLink', ['bernatfortet'])

			ddp.on('added', (data) ->
				#console.log data
			)


			onReady = ->
				console.log('onReady')
			onStop = ->
				console.log('onStop')
			onError = ->
				console.log('onError')


			ddp.sub("links", [""], onReady, onStop, onError ->
				#console.log 'subscription', 'onReady', 'onStop', 'onError'
			
			)

		)


	getTemplate: ( templateName, data ) ->
		source = $("##{templateName}").html();
		template = Handlebars.compile( source )
		if( data != '' )
			$(template(data))
		else
			$(template())



$(document).ready( ->
	app = new App()

	chrome.tabs.getSelected(null, (tab) -> 
		console.log 'test', tab
	)

)
	
