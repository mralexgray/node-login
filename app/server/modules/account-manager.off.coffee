crypto = require('crypto')
MongoDB = require('mongodb').Db
Server = require('mongodb').Server
moment = require('moment')

###
	ESTABLISH DATABASE CONNECTION
###

dbName = process.env.DB_NAME or 'node-login'
dbHost = process.env.DB_HOST or 'localhost'
dbPort = process.env.DB_PORT or 27017
db = new MongoDB(dbName, new Server(dbHost, dbPort, auto_reconnect: true), w: 1)
db.open (e, d) ->
	if e
		console.log e
	else
		if process.env.NODE_ENV == 'live'
			db.authenticate process.env.DB_USER, process.env.DB_PASS, (e, res) ->
				if e
					console.log 'mongo :: error: not authenticated', e
				else
					console.log 'mongo :: authenticated and connected to database :: "' + dbName + '"'
				return
		else
			console.log 'mongo :: connected to database :: "' + dbName + '"'
	return
accounts = db.collection('accounts')

### login validation methods ###

exports.autoLogin = (user, pass, callback) ->
	accounts.findOne { user: user }, (e, o) ->
		if o
			if o.pass == pass then callback(o) else callback(null)
		else
			callback null
		return
	return

exports.manualLogin = (user, pass, callback) ->
	accounts.findOne { user: user }, (e, o) ->
		if o == null
			callback 'user-not-found'
		else
			validatePassword pass, o.pass, (err, res) ->
				if res
					callback null, o
				else
					callback 'invalid-password'
				return
		return
	return

### record insertion, update & deletion methods ###

exports.addNewAccount = (newData, callback) ->
	accounts.findOne { user: newData.user }, (e, o) ->
		if o
			callback 'username-taken'
		else
			accounts.findOne { email: newData.email }, (e, o) ->
				if o
					callback 'email-taken'
				else
					saltAndHash newData.pass, (hash) ->
						newData.pass = hash
						# append date stamp when record was created //
						newData.date = moment().format('MMMM Do YYYY, h:mm:ss a')
						accounts.insert newData, { safe: true }, callback
						return
				return
		return
	return

exports.updateAccount = (newData, callback) ->
	accounts.findOne { _id: getObjectId(newData.id) }, (e, o) ->
		o.name = newData.name
		o.email = newData.email
		o.country = newData.country
		if newData.pass == ''
			accounts.save o, { safe: true }, (e) ->
				if e
					callback e
				else
					callback null, o
				return
		else
			saltAndHash newData.pass, (hash) ->
				o.pass = hash
				accounts.save o, { safe: true }, (e) ->
					if e
						callback e
					else
						callback null, o
					return
				return
		return
	return

exports.updatePassword = (email, newPass, callback) ->
	accounts.findOne { email: email }, (e, o) ->
		if e
			callback e, null
		else
			saltAndHash newPass, (hash) ->
				o.pass = hash
				accounts.save o, { safe: true }, callback
				return
		return
	return

### account lookup methods ###

exports.deleteAccount = (id, callback) ->
	accounts.remove { _id: getObjectId(id) }, callback
	return

exports.getAccountByEmail = (email, callback) ->
	accounts.findOne { email: email }, (e, o) ->
		callback o
		return
	return

exports.validateResetLink = (email, passHash, callback) ->
	accounts.find { $and: [ {
		email: email
		pass: passHash
	} ] }, (e, o) ->
		callback if o then 'ok' else null
		return
	return

exports.getAllRecords = (callback) ->
	accounts.find().toArray (e, res) ->
		if e
			callback e
		else
			callback null, res
		return
	return

exports.delAllRecords = (callback) ->
	accounts.remove {}, callback
	# reset accounts collection for testing //
	return

### private encryption & validation methods ###

generateSalt = ->
	set = '0123456789abcdefghijklmnopqurstuvwxyzABCDEFGHIJKLMNOPQURSTUVWXYZ'
	salt = ''
	i = 0
	while i < 10
		p = Math.floor(Math.random() * set.length)
		salt += set[p]
		i++
	salt

md5 = (str) ->
	crypto.createHash('md5').update(str).digest 'hex'

saltAndHash = (pass, callback) ->
	salt = generateSalt()
	callback salt + md5(pass + salt)
	return

validatePassword = (plainPass, hashedPass, callback) ->
	salt = hashedPass.substr(0, 10)
	validHash = salt + md5(plainPass + salt)
	callback null, hashedPass == validHash
	return

getObjectId = (id) ->
	new require('mongodb').ObjectID id

findById = (id, callback) ->
	accounts.findOne { _id: getObjectId(id) }, (e, res) ->
		if e
			callback e
		else
			callback null, res
		return
	return

findByMultipleFields = (a, callback) ->
	# this takes an array of name/val pairs to search against {fieldName : 'value'} //
	accounts.find($or: a).toArray (e, results) ->
		if e
			callback e
		else
			callback null, results
		return
	return
