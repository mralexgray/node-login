[moment,crypto] = (require x for x in ['moment','crypto'])
MongoDB = require('mongodb').Db
Server = require('mongodb').Server

# ESTABLISH DATABASE CONNECTION

dbName = process.env.DB_NAME or 'node-login'
dbHost = process.env.DB_HOST or 'localhost'
dbPort = process.env.DB_PORT or 27017
db = new MongoDB(dbName, new Server(dbHost, dbPort, auto_reconnect: true), w: 1)
db.open (e, d) ->
  if e then console.log e
  else
    if process.env.NODE_ENV == 'live'
      db.authenticate process.env.DB_USER, process.env.DB_PASS, (e, res) ->
        if e
          console.log 'mongo :: error: not authenticated', e
        else
          console.log 'mongo :: authenticated and connected to database :: "' + dbName + '"'
    else
      console.log 'mongo :: connected to database :: "' + dbName + '"'

accounts = db.collection 'accounts'

### login validation methods ###

exports.autoLogin = (user, pass, callback) ->
  accounts.findOne { user: user }, (e, o) ->
    if o then	return (o.pass is pass and callback o or callback null)
		callback null

exports.manualLogin = (user, pass, callback) ->
  accounts.findOne { user: user }, (e, o) ->
    if o is null then callback 'user-not-found'
    else
      validatePassword pass, o.pass, (err, res) ->
        res? and callback null, o or callback 'invalid-password'

### record insertion, update & deletion methods ###

exports.addNewAccount = (newData, callback) ->
  accounts.findOne { user: newData.user }, (e, o) ->
    if o then return callback 'username-taken'
    accounts.findOne { email: newData.email }, (e, o) ->
      if o then return callback 'email-taken'
      saltAndHash newData.pass, (hash) ->
        newData.pass = hash
        # append date stamp when record was created //
        newData.date = moment().format('MMMM Do YYYY, h:mm:ss a')
        accounts.insert newData, { safe: true }, callback

exports.updateAccount = (newData, callback) ->
  accounts.findOne { _id: getObjectId(newData.id) }, (e, o) ->
    o.name = newData.name
    o.email = newData.email
    o.country = newData.country
    if newData.pass == ''
      accounts.save o, { safe: true }, (e) ->
        e? and callback e or callback null, o
    else
      saltAndHash newData.pass, (hash) ->
        o.pass = hash
        accounts.save o, { safe: true }, (e) ->
          e? and callback e or callback null, o

exports.updatePassword = (email, newPass, callback) ->
  accounts.findOne { email: email }, (e, o) ->
    if e then return callback e, null
    saltAndHash newPass, (hash) ->
      o.pass = hash
      accounts.save o, { safe: true }, callback

### account lookup methods ###

exports.deleteAccount = (id, callback) ->
  accounts.remove { _id: getObjectId(id) }, callback

exports.getAccountByEmail = (email, callback) ->
  accounts.findOne { email: email }, (e, o) -> callback o

exports.validateResetLink = (email, passHash, callback) ->
  accounts.find { $and: [ {
    email: email
    pass: passHash
  } ] }, (e, o) ->
    callback if o then 'ok' else null

exports.getAllRecords = (callback) ->
  accounts.find().toArray (e, res) -> e? and callback e or callback null, res

exports.delAllRecords = (callback) -> accounts.remove {}, callback
  # reset accounts collection for testing //

### private encryption & validation methods ###

generateSalt = ->
  set = '0123456789abcdefghijklmnopqurstuvwxyzABCDEFGHIJKLMNOPQURSTUVWXYZ'
  salt = ''
  for i in [0..9]
    p = Math.floor(Math.random() * set.length)
    salt += set[p]
  salt

md5 = (str) ->
  crypto.createHash('md5').update(str).digest 'hex'

saltAndHash = (pass, callback) ->
  salt = generateSalt()
  callback salt + md5(pass + salt)

validatePassword = (plainPass, hashedPass, callback) ->
  salt = hashedPass.substr(0, 10)
  validHash = salt + md5(plainPass + salt)
  callback null, hashedPass is validHash

getObjectId = (id) -> new require('mongodb').ObjectID id

findById = (id, callback) ->
  accounts.findOne { _id: getObjectId(id) }, (e, res) ->
    e? and callback e or callback null, res

findByMultipleFields = (a, callback) ->
  # this takes an array of name/val pairs to search against {fieldName : 'value'} //
  accounts.find($or: a).toArray (e, results) ->
    e? and callback e or callback null, results
