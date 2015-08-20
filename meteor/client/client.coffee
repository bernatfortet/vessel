Meteor.subscribe "links"
	
Template.body.helpers
	links: ->
		Links.find
			sent: false
		,
			sort:
				createdAt: -1

Template.body.helpers
	sent_links: ->
		Links.find
			sent: true
		,
			sort:
				createdAt: -1

Template.body.events
	"submit .add-link": (event) ->
		console.log "asdf"

		linkUrl = event.targest.text.value
		Meteor.call "addLink", linkUrl

		event.target.text.value = ""

		false


	"click .remove": (event) ->
		Meteor.call "removeLink", this._id


	"click .sendEmailToUser": (event) ->
		#userId = $(event.currentTarget).parent().find('input').val()
		#Meteor.call "sendMandrillEmail", userId

		userEmail = $('#SendToEmail').val()

		linksIdList = []
		$.each( $('input[type="checkbox"]:checked'), ->
			console.log( $(this) )
			linksIdList.push( $(this).parent().attr('id') )
		)
		console.log 'Sending', linksIdList, userEmail 
		Meteor.call "sendLinksListToEmail", linksIdList, userEmail 

		#look at all the items with checkbox
			# Get their owner email
			#send those

		#k6iMazGXa6Ngz65zz





