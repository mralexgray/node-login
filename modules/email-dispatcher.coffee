EM = {}
module.exports = EM
EM.server = require('emailjs/email').server.connect(
	host: process.env.EMAIL_HOST or 'smtp.gmail.com'
	user: process.env.EMAIL_USER or 'your-email-address@gmail.com'
	password: process.env.EMAIL_PASS or '1234'
	ssl: true)

EM.dispatchResetPasswordLink = (account, callback) ->
	EM.server.send {
		from: process.env.EMAIL_FROM or 'Node Login <do-not-reply@gmail.com>'
		to: account.email
		subject: 'Password Reset'
		text: 'something went wrong... :('
		attachment: EM.composeEmail(account)
	}, callback
	return

EM.composeEmail = (o) ->
	link = 'https://nodejs-login.herokuapp.com/reset-password?e=' + o.email + '&p=' + o.pass
	html = '<html><body>'
	html += 'Hi ' + o.name + ',<br><br>'
	html += 'Your username is <b>' + o.user + '</b><br><br>'
	html += '<a href=\'' + link + '\'>Click here to reset your password</a><br><br>'
	html += 'Cheers,<br>'
	html += '<a href=\'https://twitter.com/braitsch\'>braitsch</a><br><br>'
	html += '</body></html>'
	[ {
		data: html
		alternative: true
	} ]
