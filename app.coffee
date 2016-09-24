###*
	* Node.js Login Boilerplate
	* More Info : http://kitchen.braitsch.io/building-a-login-system-in-node-js-and-mongodb/
	* Copyright (c) 2013-2016 Stephen Braitsch
*

###
# Reloading modules from the repl in Node.js
# Benjamin Gleitzman (gleitz@mit.edu)
#
# Inspired by Ben Barkay
# http://stackoverflow.com/a/14801711/305414
#
# Usage: `node reload.js`
# You can load the module as usual
# var mymodule = require('./mymodule')
# And the reload it when needed
# mymodule = require.reload('./mymodule')

# Removes a module from the cache.
require.uncache = (moduleName) ->
  # Run over the cache looking for the files loaded by the specified module name
  require.searchCache moduleName, (mod) ->
    delete require.cache[mod.id]

# Runs over the cache to search for all the cached files.
require.searchCache = (moduleName, callback) ->
  # Resolve the module identified by the specified name
  mod = @.resolve(moduleName)
  # Check if the module has been resolved and found within the cache
  if mod? and (mod = @.cache[mod])?
    # Recursively go over the results
    ((mod) ->
      # Go over each of the module's children and
      # run over it
      mod.children.forEach (child) ->
        run child
      # Call the specified callback providing the
      # found module
      callback mod
    ) mod

# Load a module, clearing it from the cache if necessary.

require.reload = (moduleName) ->
  @.uncache moduleName
  @ moduleName




app = require('k-cup')
	staticDirs:
		'/':			"#{process.cwd()}/app/public"
		'/holo': 	'/css/holo/assets/css'
		'/113': '/113/Site'
	locals:
		logo: '/113/113w15.logo.new.inverse.png'
		sections: do -> 
			x = require.reload './site'
			console.log 'reloaded: '+x
			x

glamourShots = (base,pub) ->
	console.log "search pat #{patt = base + '*.@(png|jpeg|jpg)'}"
	z = glob.sync patt
	.map (c) -> src: "#{pub}/#{path.basename c}"
	slides: z
	preload: true
	transition: 'blur'
	

imgs = glamourShots "/113/Site/#{pub = 'public/img/glamour'}/", "/113/#{pub}"
console.log imgs

app.io.on 'connection', (s) ->
	
	app.sock = s
	console.log "socket conected." ## : #{require('util').inspect s}"
	s.emit x,y for x,y of {
		# person: name: 'Rene', age: 26
		# notify: type: "success", message: "Woohoo! Connected!"
		carousel: imgs }

app.listen()

# http = require('http')
# express = require('express')
# session = require('express-session')
# bodyParser = require('body-parser')
# errorHandler = require('errorhandler')
# cookieParser = require('cookie-parser')
# MongoStore = require('connect-mongo')(session)
# assets = require('connect-assets')

# app = express()
# app.locals.pretty = true
# app.set 'port', process.env.PORT or 3000
# app.set 'views', __dirname + '/app/server/views'
# app.set 'view engine', 'jade'
# app.use cookieParser()
# app.use bodyParser.json()
# app.use bodyParser.urlencoded(extended: true)
# app.use require('stylus').middleware(src: __dirname + '/app/public')
# app.use express.static(__dirname + '/app/public')
# build mongo database connection url //
# dbHost = process.env.DB_HOST or 'localhost'
# dbPort = process.env.DB_PORT or 27017
# dbName = process.env.DB_NAME or 'node-login'
# dbURL = 'mongodb://' + dbHost + ':' + dbPort + '/' + dbName
# if app.get('env') is 'live'
# 	# prepend url with authentication credentials // 
# # 	dbURL = 'mongodb://' + process.env.DB_USER + ':' + process.env.DB_PASS + '@' + dbHost + ':' + dbPort + '/' + dbName
# # app.use session(
# # 	secret: 'faeb4453e5d14fe6f6d04637f78077c76c73d1b4'
# # 	proxy: true
# # 	resave: true
# # 	saveUninitialized: true
# # 	store: new MongoStore(url: dbURL))


# # require('./app/server/routes') app


# http.createServer(app).listen 5000, ->
# 	console.log 'Express server listening on port ' + app.get('port')
