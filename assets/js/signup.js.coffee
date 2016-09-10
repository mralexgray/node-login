# $(document).ready ->
av = new AccountValidator()
sc = new SignupController()
$('#account-form').ajaxForm
	beforeSubmit: (formData, jqForm, options) ->
		av.validateForm()
	success: (responseText, status, xhr, $form) ->
		if status is 'success'
			$('.modal-alert').modal 'show'
	error: (e) ->
		if e.responseText is 'email-taken'
			av.showInvalidEmail()
		else if e.responseText is 'username-taken'
			av.showInvalidUserName()

$('#name-tf').focus()
# customize the account signup form //
$('#account-form h2').text 'Signup'
$('#account-form #sub1').text 'Please tell us a little about yourself'
$('#account-form #sub2').text 'Choose your username & password'
$('#account-form-btn1').html 'Cancel'
$('#account-form-btn2').html 'Submit'
$('#account-form-btn2').addClass 'btn-primary'
# setup the alert that displays when an account is successfully created //
$('.modal-alert').modal
	show: false
	keyboard: false
	backdrop: 'static'
$('.modal-alert .modal-header h4').text 'Account Created!'
$('.modal-alert .modal-body p').html 'Your account has been created.</br>Click OK to return to the login page.'
