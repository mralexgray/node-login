class LoginValidator

	showLoginError: (t, m) ->
		showErrors t + ' ' + m

	validateForm: ->
		if $('#user-tf').val() is ''
			@showLoginError 'Whoops!', 'Please enter a valid username'
			return false
		else if $('#pass-tf').val() is ''
			@showLoginError 'Whoops!', 'Please enter a valid password'
			return false
		true

# closeConfirm: true,
# upper: true
# });
# $('.modal-alert .modal-header h4').text(t)
# $('.modal-alert .modal-body').html(m)
# this.loginErrors.modal('show')
# bind a simple alert window to this controller to display any errors //
# this.loginErrors = $('.modal-alert')
