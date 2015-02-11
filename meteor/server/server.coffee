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

	test: () ->
		console.log this.User()



	sendEmailToAllUsers: () ->
		users = Meteor.users.find()
		users.forEach (user) ->
			Meteor.call( 'sendMandrillEmail', user._id )
		

	sendMandrillEmail: ( userId ) ->
		console.log userId



		#Links.find({ sent: false, owner: 'H6pSpSSiFKbzsEPvd' }, { limit: 3 }).fetch()
		#Links.update({ sent: false, owner: 'H6pSpSSiFKbzsEPvd' }, { $set: {sent: true } })


		unsentEmails = Links.find({ sent: false, owner: userId }, { limit: 3 }).fetch()
		console.log 'unsentMEails', unsentEmails.length

		if( unsentEmails.length >= 3 )

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



			
			Links.update({ sent: false, owner: userId }, { $set: {sent: true } })
			Links.update({ sent: false, owner: userId }, { $set: {sent: true } })
			Links.update({ sent: false, owner: userId }, { $set: {sent: true } })

			console.log email


SyncedCron.add
	name: 'Send Links Digest'
	schedule: (parser) ->
		return parser.text('at 7:00pm every day')
	job: ->
		Meteor.call('sendEmailToAllUsers', 'sent by Cron')

	SyncedCron.start()