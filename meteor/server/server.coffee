Meteor.publish( 'links', ->
	return Links.find(
		#$or: [
		#	owner: @userId
		#]
	)
)


Accounts.validateLoginAttempt( ( data ) ->
	#console.log 'test', data
	#console.log data.user._id

	return true
)


url = 'http://google.com'
filePath = 'tmp/test.png'

webshot(url, filePath, (err ) ->
	console.log 'it worked?', err
);

Meteor.methods

	test: ->
		console.log 'test'

	addLink: (linkData) ->
		console.log "Link Data ----------------"
		console.log linkData.link_title
		console.log 'owner Email', linkData.ownerEMail

		Links.insert
			link_title: linkData.link_title
			fav_icon_url: linkData.fav_icon_url
			link_url: linkData.link_url
			sent: false
			createdAt: new Date()
			owner: linkData.owner
			ownerEmail: linkData.ownerEmail


	removeLink: (linkId) ->
		console.log 'Removing Link', linkId
		Links.remove(linkId)

	test: () ->
		console.log this.User()


	sendLatest3LinksToAllUsers: () ->
		users = Meteor.users.find()
		users.forEach (user) ->
			Meteor.call( 'sendMandrillEmail', user._id )

	sendLatest3LinksToUser: ( userId ) ->



		#Links.find({ sent: false, owner: 'H6pSpSSiFKbzsEPvd' }, { limit: 3 }).fetch()
		#Links.update({ sent: false, owner: 'H6pSpSSiFKbzsEPvd' }, { $set: {sent: true } })


		#unsentEmails = Links.find({ sent: false, owner: userId }, { limit: 3 }).fetch()
		unsentEmails = Links.find({ sent: false }, { limit: 3 }).fetch()
		console.log 'unsentMEails', unsentEmails.length

		

	sendLinksListToEmail: ( linksIdList, userEmail ) ->
		console.log 'linksIdList', linksIdList

		linksList = []
		for i in [0...linksIdList.length]
			link = Links.findOne({ _id: linksIdList[i] })
			linksList.push(link)

		console.log 'linksList', linksList

		Meteor.call( 'sendEmail', linksList, userEmail )


	sendEmail: ( linksList, userEmail ) ->

		console.log 'sendingEmail', userEmail, linksList, linksList[0].link_title


		global_merge_vars = []
		for i in [0...linksList.length]
			object = {}
			object.name = 'link' + i
			object.content = linksList[i]
			global_merge_vars.push( object )

		console.log global_merge_vars

		email = Meteor.Mandrill.sendTemplate
			template_name: 'links-digest'
			template_content: [
				{
					name: "header"
					content: "Hello b"
				}
			]
			message:
				global_merge_vars: global_merge_vars
				from_email: 'socrattes@gmail.com'
				to: [email: userEmail]



		for i in [0...linksList.length]
			console.log 'Updating Link #{linksList[i]} to sent'
			Links.update({ _id: linksList[i]._id }, { $set: {sent: true } })
			
		console.log 'Email sent:'
		console.log email


###
SyncedCron.add
	name: 'Send Links Digest'
	schedule: (parser) ->
		return parser.text('at 7:00pm every day')
	job: ->
		Meteor.call('sendEmailToAllUsers', 'sent by Cron')

	SyncedCron.start()
###