###*
	* Node.js Login Boilerplate
	* More Info : http://kitchen.braitsch.io/building-a-login-system-in-node-js-and-mongodb/
	* Copyright (c) 2013-2016 Stephen Braitsch
*
###
cdn = '//cdnjs.cloudflare.com'
locals =
	defaultCSS : [
		'/bootstrap/css'
		'/build/node-login.css'
		'overhang/dist/overhang.min.css']
# '/holo/assets/css/holo.css'
	defaultCS: [
		'/js/controllers/socketController.coffee'
	]
	defaultJS: [
		"#{cdn}/ajax/libs/jquery/3.1.0/jquery.js"
		"#{cdn}/ajax/libs/jqueryui/1.10.4/jquery-ui.min.js"
		'/bootstrap/js'
		'/vendor/jquery.form.min.js'
		'/vendor/cs.js'
		'/overhang/dist/overhang.min.js'
		'/socket.io-client/socket.io.js']

__ = require 'thebasics'

mods = {
	'nib','bodyParser','errorhandler','cookieParser','path','http','express', 'stylus', 'util'
	bs:'express-bootstrap-service'
	# coffee: 'express-@'
	session:'express-@'
	sharedsession:'express-socket.io-session'}

# __.need mods

for x,y of mods
	mod = y.replace '@',x
	mod = _.dasherize mod
	global[x] = require mod


# [ nib,bs,path,http,express,session
	# bodyParser,errorHandler,cookieParser
	# stylus,sharedsession,util ] =
	# require x for x in ['nib','express-bootstrap-service','path','http','express','express-session','body-parser','errorhandler','cookie-parser','stylus','express-socket.io-session','util']

MongoStore = require('connect-mongo') session
app        = express()
server 		 = require('http').createServer app
io 				 = require('socket.io') server

for x in ['partials/','public/']
	app.use stylus.middleware
		sourcemap: true
		src: 	path.resolve __dirname, x
		dest:	path.resolve __dirname,'public/build/'
		compile: (str, path) ->
			stylus(str).set('filename', path).set('compress', false).use nib()


app.set 'port', process.env.PORT or 3000
app.set 'views', path.join(__dirname,'server/views')
app.set 'view engine', 'pug'
app.use require('morgan')('dev')
 
app.use cookieParser()
app.use	bodyParser.json()
app.use bodyParser.urlencoded extended: true
app.use bs.serve

# app.use coffee
# 	path: __dirname + '/public'
# 	live: true
# 	uglify: false

app.use uri, express.static(loc) for uri,loc of {
	'/113': '/113/Site'
	'/holo': '/css/holo' }
app.use express.static(path.resolve __dirname, z) for z in [
	'public'
	'partials'
	'node_modules']

app.locals = require('underscore').extend locals, pretty: true, siteName: '113w15.com'

# build mongo database connection url 
dbHost = process.env.DB_HOST or 'localhost'
dbPort = process.env.DB_PORT or 27017
dbName = process.env.DB_NAME or 'node-login'
dbURL = "mongodb://#{dbHost}:#{dbPort}/#{dbName}"
# app.get('env') isnt 'live' and  or 
	# prepend url with authentication credentials
	#"mongodb://#{process.env.DB_USER}:#{process.env.DB_PASS}@#{dbHost}:#{dbPort}/#{dbName}"
app.use session(
	secret: 'faeb4453e5d14fe6f6d04637f78077c76c73d1b4'
	proxy: true
	resave: true
	saveUninitialized: true
	store: new MongoStore(url: dbURL))

#io.use sharedsession(session, {autoSave: true})
				 
io.on 'connection', (socket) ->
	
	person = {name: 'Rene', age: 26}
	io.emit 'person', person
	io.emit 'notify', type: "success", message: "Woohoo! Connected!"
	io.emit 'jq', '#logo': { css: { backgroundColor: 'green'}}
	
	# Accept a login event with user's data
	socket.on 'login', (userdata) ->
		socket.handshake.session.userdata = userdata
	socket.on 'logout', (userdata) ->
		if socket.handshake.session.userdata
			delete socket.handshake.session.userdata


require('./server/routes') app

printClients = ->
	console.log "io.clients: #{Object.keys io.sockets.clients().sockets}"
	setTimeout printClients, 5000

server.listen app.get('port'), ->
	console.log 'Express server listenning on port ' + app.get('port')
	printClients()


###
var is = i.map(function(z){ return lpath + '/' + z; });

fs = require('fs')
_ = require('underscore')
p = require('path')
lpath = '/public/img/glamour'
cpath = '/113/Site' + lpath
exts = [
	'png'
	'jpeg'
	'jpg'
]
console.log 'just car is ' + (car = fs.readdirSync(cpath))
carf = car.filter (x) -> 
	ext = x.split('.').pop()
	_(exts).contains(ext)

cars = carf.map (x) -> p.join(lpath,x)
console.log cars

# console.log 'carf is ' + (

		# if () {
		# f = p.join(lpath, x)
		# console.log 'found ' + f
		# app.locals.images += f
		# }

	# console.log 'is is ' + app.locals.images

app.locals.images =  JSON.stringify cars

console.log 'is is ' + car
###
