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

		linkUrl = event.target.text.value
		Meteor.call "addLink", linkUrl

		event.target.text.value = ""

		false


	"click .remove": (event) ->
		Meteor.call "removeLink", this._id
