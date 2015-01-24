Meteor.publish( 'links', ->
	return Links.find(
		$or: [
			owner: @userId
		]
	)
)


Meteor.methods

	addLink: (linkData) ->
		console.log 'Adding Link. Next log should say bernatfortet.com'
		console.log linkData

		Links.insert
			link_title: linkData.link_title
			fav_icon_url: linkData.fav_icon_url
			link_url: linkData.link_url
			sent: false
			createdAt: new Date()


	removeLink: (linkId) ->
		console.log 'Removing Link', linkId

		Links.remove(linkId)




	sendEmail: (test) ->

		LINKS_PER_EMAIL = 3

		unsentEmails = Links.find({ sent: false}, { limit: LINKS_PER_EMAIL }).fetch()

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

		this.unblock()


		#Meteor.call( 'sendMandrillEmail' )

	sendMandrillEmail: (data) ->

		test = Meteor.Mandrill.sendTemplate
			template_name: 'links-digest'
			template_content: [
				{
					name: "header"
					content: "Hello b"
				}
				{
					name: "link1"
					content: "herea re the links"
				}
				{
					name: "link2"
					content: "herea re the links"
				}
				{
					name: "link3"
					content: "herea re the links"
				}
			]
			message:
				global_merge_vars: [
					name: "var1"
					content: "Global Value 1"
				]
				merge_vars: [
					rcpt: "email@example.com"
					vars: [
						{
							name: "fname"
							content: "John"
						}
						{
							name: "lname"
							content: "Smith"
						}
					]
				]
				from_email: 'email@example.com'
				to: [email: "socrattes@gmail.com"]


		console.log test
		###
		Meteor.Mandrill.send
			to: 'socrattes@gmail.com'
			from: 'test@test.com'
			subject: 'Your Links'
			html: data
		###


SyncedCron.add
	name: 'Send Links Digest'
	schedule: (parser) ->
		return parser.text('every 10 seconds')
	job: ->
		Meteor.call('sendEmail', 'sent by Cron')

#	SyncedCron.start()