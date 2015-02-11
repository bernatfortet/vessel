
#environment = 'production' #process.env.NODE_ENV
#environment = 'development'

devTwitter =
	consumerKey: "v9TuHPWhGk0PLAZp0BPsBBygB"
	secret: "hzxUHvCltJEY6SYfzbdz2yvTrbTvsh618joLBUVxPGaG6sADTR"

prodTwitter =
	consumerKey: "FSUVuyLl529X332lw8sqYNT9i"
	secret: "n6cpLFyE9SRYoQk2pCYFJItwtyQgf0DvF3UDtqqiez1nw5YpE0"

devFacebook =
	appId: "628637753932458"
	secret: "5e5fc08c5c36e3469032e2df451e76d1"
prodFacebook =
	appId: "597081757088058"
	secret: "043ff074dce32cf3c992cd7b027f50c5"


###


console.log( environment)

ServiceConfiguration.configurations.remove
	service: "twitter"

ServiceConfiguration.configurations.remove
	service: "facebook"



if( environment == 'development' )
	ServiceConfiguration.configurations.insert
		service: "twitter"
		loginStyle: "redirect"
		consumerKey: devTwitter.consumerKey
		secret: devTwitter.secret
	ServiceConfiguration.configurations.insert
		service: "facebook"
		loginStyle: "popup"
		appId: devFacebook.appId
		secret: devFacebook.secret

else 
	ServiceConfiguration.configurations.insert
		service: "twitter"
		loginStyle: "redirect"
		consumerKey: prodTwitter.consumerKey
		secret: prodTwitter.secret
	ServiceConfiguration.configurations.insert
		service: "facebook"
		loginStyle: "popup"
		appId: prodFacebook.appId
		secret: prodFacebook.secret

###

ServiceConfiguration.configurations.remove
	service: "twitter"

ServiceConfiguration.configurations.insert
	service: "twitter"
	loginStyle: "redirect"
	consumerKey: devTwitter.consumerKey
	secret: devTwitter.secret