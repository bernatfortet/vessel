Meteor.publish( 'links', ->
	return Links.find(
		$or: [
			owner: @userId
		]
	)
)



Accounts.validateLoginAttempt( ( data ) ->
	#console.log 'test', data
	#console.log data.user._id

	return true
)

Meteor.methods

	test: ->
		console.log 'test'

	addLink: (linkData) ->
		console.log "Link Data ----------------"
		console.log linkData.link_title

		Links.insert
			link_title: linkData.link_title
			fav_icon_url: linkData.fav_icon_url
			link_url: linkData.link_url
			sent: false
			createdAt: new Date()
			owner: linkData.owner


	removeLink: (linkId) ->
		console.log 'Removing Link', linkId
		Links.remove(linkId)




	sendEmail: (test) ->

		LINKS_PER_EMAIL = 3

		unsentEmails = Links.find({ sent: false}, { limit: 3 }).fetch()

		#console.log 'unsentEmails', unsentEmails.fetch()


		link1 = Links.update({ sent: false}, { $set: {sent: true } })
		link2 = Links.update({ sent: false}, { $set: {sent: true } })
		link3 = Links.update({ sent: false}, { $set: {sent: true } })

		console.log link1.link_title
		console.log link2.link_title
		console.log link3.link_title

		
		#take all unset emails
		#mark them as sent

		console.log 'sending email'

		#this.unblock()


		#Meteor.call( 'sendMandrillEmail' )

	sendMandrillEmail: () ->


		unsentEmails = Links.find({ sent: false}, { limit: 3 }).fetch()

		email = Meteor.Mandrill.sendTemplate
			template_name: 'links-digest'
			template_content: [
				{
					name: "header"
					content: "Hello b"
				}
			]
			message:
				global_merge_vars: [
					{
						name: "link1_name"
						content: unsentEmails[0].link_title
					}
					{
						name: "link1_url"
						content: unsentEmails[0].link_url
					}
					{
						name: "link2_name"
						content: unsentEmails[1].link_title
					}
					{
						name: "link2_url"
						content: unsentEmails[1].link_url
					}
					{
						name: "link3_name"
						content: unsentEmails[2].link_title
					}
					{
						name: "link3_url"
						content: unsentEmails[2].link_url
					}
				]
				from_email: 'email@example.com'
				to: [email: "socrattes@gmail.com"]


		console.log email


SyncedCron.add
	name: 'Send Links Digest'
	schedule: (parser) ->
		return parser.text('every 10 seconds')
	job: ->
		Meteor.call('sendEmail', 'sent by Cron')

#	SyncedCron.start()