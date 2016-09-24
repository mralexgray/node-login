# var AM = require(__dirname + '/modules/account-manager');
[CT,EM] = (require __dirname + '/modules/' + x for x in ['country-list','email-dispatcher'])

module.exports = (app) ->

	
	
	app.locals.countries = CT
	app.get '/', (req, res) -> # main login page
		login = ->
			res.render 'index',
				load: 'login',	title: 'Hello - Please Login To Your Account'

		# check if the user's credentials are saved in a cookie //
		return login() if not req.cookies.user? or not req.cookies.pass?
		# attempt automatic login 
		app.AM.autoLogin req.cookies.user, req.cookies.pass, (o) ->
			return login() if o is null
			req.session.user = o
			res.redirect '/home'
			
	app.post '/', (req, res) ->
		
		app.AM.manualLogin req.body['user'], req.body['pass'], (e, o) ->
			
			return res.status(400).send e if not o
			
			req.session.user = o
			if req.body['remember-me'] is 'true'
				res.cookie 'user', o.user, maxAge: 900000
				res.cookie 'pass', o.pass, maxAge: 900000
			res.status(200).send o

	
	app.get '/home', (req, res) -> # logged-in user homepage
		
		# if user is not logged-in redirect back to login page
		return res.redirect '/' if req.session.user is null
		res.render 'home',
			udata: req.session.user, title: 'Control Panel', countries: CT
			

	app.post '/home', (req, res) ->
		return res.redirect '/' if req.session.user is null
		app.AM.updateAccount {
			id: req.session.user._id
			name: req.body['name']
			email: req.body['email']
			pass: req.body['pass']
			country: req.body['country']
		}, (e, o) ->
			if e
				res.status(400).send 'error-updating-account'
			else
				req.session.user = o
				# update the user's login cookies if they exists //
				if req.cookies.user? and req.cookies.pass?
					res.cookie x, o[x], maxAge: 900000 for x in ['user','pass']
				res.status(200).send 'ok'

	app.post '/logout', (req, res) ->
		res.clearCookie x for x in ['user','pass']
		req.session.destroy (e) -> res.status(200).send 'ok'
	
	app.get '/signup', (req, res) -> # creating new accounts
		res.render 'signup',
			title: 'Signup'
			countries: CT
			
	app.post '/signup', (req, res) ->
		app.AM.addNewAccount _.mapObject(req.body, ['name','email','user','pass','country']), (e) ->
			res.status(e and 400 or 200).send e or 'ok'
	
	# password reset 
	app.post '/lost-password', (req, res) ->
		# look up the user's account via their email //
		@AM.getAccountByEmail req.body['email'], (o) ->
			return res.status(400).send 'email-not-found' if not o?
			EM.dispatchResetPasswordLink o, (e, m) ->
				# this callback takes a moment to return //
				# TODO add an ajax loader to give user feedback //
				return res.status(200).send 'ok' if not e
				console.log 'ERROR : ', k, e[k] for k of e
				res.status(400).send 'unable to dispatch password reset'
				
	app.get '/reset-password', (req, res) ->
		
		[email,passH] = (req.query[x] for x in ['e','p'])
	
		@AM.validateResetLink email, passH, (e) ->
	
			return res.redirect '/' if e isnt 'ok'
			# save the user's email in a session instead of sending to the client //
			req.session.reset =
				email: email
				passHash: passH
			res.render 'reset', title: 'Reset Password'

	app.post '/reset-password', (req, res) ->
		nPass = req.body['pass']
		# retrieve the user's email from the session to lookup their account and reset password //
		email = req.session.reset.email
		# destory the session immediately after retrieving the stored email //
		req.session.destroy()
		@AM.updatePassword email, nPass, (e, o) ->
			res.status(o and 200 or 400).send o and 'ok' or 'unable to update password'

	
	app.get '/print', (req, res) -> # view & delete accounts 
		@AM.getAllRecords (e, accounts) ->
			res.render 'print',
				title: 'Account List'
				accts: accounts

	app.post '/delete', (req, res) ->
		@AM.deleteAccount req.body.id, (e, obj) ->
			return res.status(400).send 'record not found' if e?
			res.clearCookie x for x in ['user','pass']
			req.session.destroy (e) -> res.status(200).send 'ok'
				

	app.get '/reset', (req, res) -> @AM.delAllRecords -> res.redirect '/print'

	app.get '*', (req, res, next) ->
		# console.log(util.inspect(req));
		p = path.basename(req.originalUrl)
		console.log 'path is ' + p
		res.render p, {}, (err, html) ->
			if err?
				console.log err
				return next()
			else res.send html
			
				
	###
			render = array(app.get('views')).some(function(v){
				var d = path.join(v,req.route.path);
				console.log('evaluating ' + d)
				return fs.existsSync(d)
			});
			if (render.length) {
				console.log('[render] ' + req.route.path);
				res.render(path.basename(render[0]));
			}
	###

	# next()
	# });

	###
	app.use(function(req, res) { 
		// array(app.get 'views').some (v) ->
			// if fs    		
	// 	res.render('index', { load: '/login', title: 'Hello - Please Login To Your Account' });		
	// 	res.render('404', { title: 'Page Not Found'}); 
	// });
	// app.get('*', function(req, res) { res.render('404', { title: 'Page Not Found'}); });
	###

