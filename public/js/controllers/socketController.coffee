window['SocketController'] = ->

	(socket = io()).on key, val for key,val of {
		
		jq: (q) -> $(key)[sel] q[key][sel] for sel of q[key] for key of q
		
		# Whenever the server emits 'login', log the login message
		login: (data) ->
			# Display the welcome message
			$('body').overhang type: 'success',message: 'Welcome to Socket.IO Chat'

		data: (d) -> console.log 'data', d

		error: (r) -> console.error 'Unable to connect Socket.IO', r

		connect: ->	console.info 'successfully established a working and authorized connection'

		person: (p) ->	console.log "#{p.name} is #{p.age} years old."

		notify: (note) -> $('body').overhang(note)
		}
	socket
