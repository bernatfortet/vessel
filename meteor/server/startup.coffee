Meteor.startup ->

	Meteor.Mandrill.config
		username: 'socrattes@gmail.com'
		key: 'gnrTHAhbdEuaEzmWscnckA'


	Meteor.call( 'sendEmailToAllUsers' )
	#Meteor.call( 'sendMandrillEmail' )
	#Meteor.call( 'test' )

	


