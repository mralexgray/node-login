###*
	* Node.js Login Boilerplate
	* More Info : http://kitchen.braitsch.io/building-a-login-system-in-node-js-and-mongodb/
	* Copyright (c) 2013-2016 Stephen Braitsch
*
###
[http,express,session,bodyParser,errorHandler,cookieParser] =
	require x for x in ['http','express','express-session','body-parser','errorhandler','cookie-parser']

MongoStore = require('connect-mongo')(session)
app = express()
app.use require('stylus').middleware(src: '/node/partials')
app.use '/113', express.static('/113/Site')
app.use '/partials', express.static('/node/partials')
app.locals = pretty: true
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

# var is = i.map(function(z){ return lpath + '/' + z; });
app.set 'port', process.env.PORT or 3000
app.set 'views', __dirname + '/app/server/views'
app.set 'view engine', 'jade'
app.use cookieParser()
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: true)
app.use require('stylus').middleware(src: __dirname + '/app/public')
app.use express.static(__dirname + '/app/public')
# build mongo database connection url //
dbHost = process.env.DB_HOST or 'localhost'
dbPort = process.env.DB_PORT or 27017
dbName = process.env.DB_NAME or 'node-login'
dbURL = 'mongodb://' + dbHost + ':' + dbPort + '/' + dbName
if app.get('env') == 'live'
  # prepend url with authentication credentials // 
  dbURL = 'mongodb://' + process.env.DB_USER + ':' + process.env.DB_PASS + '@' + dbHost + ':' + dbPort + '/' + dbName
app.use session(
  secret: 'faeb4453e5d14fe6f6d04637f78077c76c73d1b4'
  proxy: true
  resave: true
  saveUninitialized: true
  store: new MongoStore(url: dbURL))
require('./app/server/routes') app
http.createServer(app).listen app.get('port'), ->
  console.log 'Express server listening on port ' + app.get('port')
