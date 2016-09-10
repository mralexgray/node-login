###*
	* Node.js Login Boilerplate
	* More Info : http://kitchen.braitsch.io/building-a-login-system-in-node-js-and-mongodb/
	* Copyright (c) 2013-2016 Stephen Braitsch
*
###

app = require('k-cup')
	staticDirs:
		'/':			"#{process.cwd()}/app/public"
		'/holo': 	'/css/holo/assets/css'

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

app.listen 4030, -> console.log 'port 4030'

# http.createServer(app).listen 5000, ->
# 	console.log 'Express server listening on port ' + app.get('port')
