EmailValidator = ->
  # bind this to _local for anonymous functions //
  _local = this
  # modal window to allow users to request credentials by email //
  _local.retrievePassword = $('#get-credentials')
  _local.retrievePasswordAlert = $('#get-credentials .alert')
  _local.retrievePassword.on 'show.bs.modal', ->
    $('#get-credentials-form').resetForm()
    _local.retrievePasswordAlert.hide()
    return
  return

EmailValidator::validateEmail = (e) ->
  re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
  re.test e

EmailValidator::showEmailAlert = (m) ->
  @retrievePasswordAlert.attr 'class', 'alert alert-danger'
  @retrievePasswordAlert.html m
  @retrievePasswordAlert.show()
  return

EmailValidator::hideEmailAlert = ->
  @retrievePasswordAlert.hide()
  return

EmailValidator::showEmailSuccess = (m) ->
  @retrievePasswordAlert.attr 'class', 'alert alert-success'
  @retrievePasswordAlert.html m
  @retrievePasswordAlert.fadeIn 500
  return
