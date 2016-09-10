$(document).ready ->
	lv = new LoginValidator()
	lc = new LoginController()
	# main login form //
	$('#login').ajaxForm
		beforeSubmit: (formData, jqForm, options) ->
			return false if not lv.validateForm()
			# append 'remember-me' option to formData to write local cookie //
			formData.push
				name: 'remember-me'
				value: $('.button-rememember-me-glyph').hasClass('glyphicon-ok')
			true
		success: (responseText, status, xhr, $form) ->
			window.location.href = '/home' if status is 'success'
		error: (e) ->
			# lv.showLoginError
			showErrors 'Login Failure: Please check your username and/or password'
	$('#user-tf').focus()
	# login retrieval form via email //
	ev = new EmailValidator()
	$('#get-credentials-form').ajaxForm
		url: '/lost-password'
		beforeSubmit: (formData, jqForm, options) ->
			if ev.validateEmail($('#email-tf').val())
				ev.hideEmailAlert()
				true
			else
				# ev.showEmailAlert '
				showErrors '<b>Error!</b> Please enter a valid email address'
				false
		success: (responseText, status, xhr, $form) ->
			$('#cancel').html 'OK'
			$('#retrieve-password-submit').hide()
			ev.showEmailSuccess 'Check your email on how to reset your password.'
		error: (e) ->
			if e.responseText is 'email-not-found'
				# ev.showEmailAlert
				showErrors 'Email not found. Are you sure you entered it correctly?'
			else
				$('#cancel').html 'OK'
				$('#retrieve-password-submit').hide()
				ev.showEmailAlert 'Sorry. There was a problem, please try again later.'

