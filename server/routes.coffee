CT = require('./modules/country-list')
AM = require('./modules/account-manager')
EM = require('./modules/email-dispatcher')

module.exports = (app) ->

  # main login page
  app.get '/', (req, res) ->
    # check if the user's credentials are saved in a cookie 
    if not req.cookies.user? or not req.cookies.pass?
      return res.render 'login', title: 'Hello - Please Login To Your Account'

    # attempt automatic login 
    AM.autoLogin req.cookies.user, req.cookies.pass, (o) ->
      if o != null
        req.session.user = o
        res.redirect '/home'
      else
        res.render 'login', title: 'Hello - Pse Login To Your Account'

  app.post '/', (req, res) ->
    AM.manualLogin req.body['user'], req.body['pass'], (e, o) ->
      return res.status(400).send(e) if not o?

      req.session.user = o
      if req.body['remember-me'] == 'true'
        res.cookie 'user', o.user, maxAge: 900000
        res.cookie 'pass', o.pass, maxAge: 900000
      res.status(200).send o
  
  # logged-in user homepage 
  app.get '/home', (req, res) ->
    # if user is not logged-in redirect back to login page //
    if req.session.user is null then res.redirect '/'
    else
      res.render 'home',
        title: 'Control Panel'
        countries: CT
        udata: req.session.user

  app.post '/home', (req, res) ->

    return res.redirect '/' if not req.session.user?
    AM.updateAccount {
      id: req.session.user._id
      name: 		req.body['name']
      email: 		req.body['email']
      pass: 		req.body['pass']
      country: 	req.body['country']
    }, (e, o) ->
      return res.status(400).send('error-updating-account') if e?
        
      req.session.user = o
      # update the user's login cookies if they exists //
      if req.cookies.user isnt undefined and req.cookies.pass isnt undefined
        res.cookie 'user', o.user, maxAge: 900000
        res.cookie 'pass', o.pass, maxAge: 900000
      res.status(200).send 'ok'

  app.post '/logout', (req, res) ->
    res.clearCookie x for x in ['user','pass']
    req.session.destroy (e) -> res.status(200).send 'ok'

  # creating new accounts 
  app.get '/signup', (req, res) ->
    res.render 'signup',
      title: 'Signup'
      countries: CT

  app.post '/signup', (req, res) ->
    AM.addNewAccount
      name: req.body['name']
      email: req.body['email']
      user: req.body['user']
      pass: req.body['pass']
      country: req.body['country']
    , (e) ->
      res.status(e? and 400 or 200).send e? and e or 'ok'

  # password reset 
  app.post '/lost-password', (req, res) ->
    # look up the user's account via their email //
    AM.getAccountByEmail req.body['email'], (o) ->
      if o
        EM.dispatchResetPasswordLink o, (e, m) ->
          # this callback takes a moment to return //
          # TODO add an ajax loader to give user feedback //
          if not e? then res.status(200).send 'ok'
          else
            for k of e
              console.log 'ERROR : ', k, e[k]
            res.status(400).send 'unable to dispatch password reset'
      else
        res.status(400).send 'email-not-found'

  app.get '/reset-password', (req, res) ->
    email = req.query['e']
    passH = req.query['p']
    AM.validateResetLink email, passH, (e) ->
      if e isnt 'ok' then res.redirect '/'
      else
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
    AM.updatePassword email, nPass, (e, o) ->
      res.status(o? and 200 or 400).send o? and 'ok' or 'unable to update password'

  # view & delete accounts 
  app.get '/print', (req, res) ->
    AM.getAllRecords (e, accounts) ->
      res.render 'print',
        title: 'Account List'
        accts: accounts
  
  app.post '/delete', (req, res) ->
    AM.deleteAccount req.body.id, (e, obj) ->
      if !e
        res.clearCookie 'user'
        res.clearCookie 'pass'
        req.session.destroy (e) ->
          res.status(200).send 'ok'
      else
        res.status(400).send 'record not found'
  
  app.get '/reset', (req, res) ->
    AM.delAllRecords -> res.redirect '/print'
    
  # app.use (req, res) ->
  #   res.status(404);
  #   res.render '404', title: 'Page Not Found'

