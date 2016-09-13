AccountValidator = ->
  # build array maps of the form inputs & control groups //
  @formFields = [
    $('#name-tf')
    $('#email-tf')
    $('#user-tf')
    $('#pass-tf')
  ]
  @controlGroups = [
    $('#name-cg')
    $('#email-cg')
    $('#user-cg')
    $('#pass-cg')
  ]
  # bind the form-error modal window to this controller to display any errors //
  # this.alert = $('.modal-form-errors');
  # this.alert.modal({ show : false, keyboard : true, backdrop : true});

  @validateName = (s) ->
    s.length >= 3

  @validatePassword = (s) ->
    # if user is logged in and hasn't changed their password, return ok
    $('#userId').val() and s == '' or s.length >= 6

  @validateEmail = (e) ->
    re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    re.test e

  @showErrors = (a) ->
    showErrors a
    $('.modal-form-errors .modal-body p').text 'Please correct the following problems :'
    ul = $('.modal-form-errors .modal-body ul')
    ul.empty()
    i = 0
    while i < a.length
      ul.append '<li>' + a[i] + '</li>'
      i++
    # this.alert.modal('show');
    return

  return

AccountValidator::showInvalidEmail = ->
  @controlGroups[1].addClass 'error'
  @showErrors [ 'That email address is already in use.' ]
  return

AccountValidator::showInvalidUserName = ->
  @controlGroups[2].addClass 'error'
  @showErrors [ 'That username is already in use.' ]
  return

AccountValidator::validateForm = ->
  e = []
  i = 0
  while i < @controlGroups.length
    @controlGroups[i].removeClass 'error'
    i++
  if @validateName(@formFields[0].val()) == false
    @controlGroups[0].addClass 'error'
    e.push 'Please Enter Your Name'
  if @validateEmail(@formFields[1].val()) == false
    @controlGroups[1].addClass 'error'
    e.push 'Please Enter A Valid Email'
  if @validateName(@formFields[2].val()) == false
    @controlGroups[2].addClass 'error'
    e.push 'Please Choose A Username'
  if @validatePassword(@formFields[3].val()) == false
    @controlGroups[3].addClass 'error'
    e.push 'Password Should Be At Least 6 Characters'
  if e.length
    @showErrors e
  e.length == 0
