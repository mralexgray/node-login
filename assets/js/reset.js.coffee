$(document).ready ->
	rv = new ResetValidator
	$('#set-password-form').ajaxForm
		beforeSubmit: (formData, jqForm, options) ->
			rv.hideAlert()
			if rv.validatePassword($('#pass-tf').val()) == false
				false
			else
				true
		success: (responseText, status, xhr, $form) ->
			rv.showSuccess 'Your password has been reset.'
			setTimeout (->
				window.location.href = '/'
				return
			), 3000
			return
		error: ->
			rv.showAlert 'I\'m sorry something went wrong, please try again.'
			return
	$('#set-password').modal 'show'
	$('#set-password').on 'shown', ->
		$('#pass-tf').focus()
		return
	return
