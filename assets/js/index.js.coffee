	window['eep'] = ->
		sound = new Howl(
			src: ['/sounds/eep.wav']
			autoplay: true
			volume: 0.5
			loop: false)
		sound.play()

	window['showErrors'] = (e) ->
		errs = typeof e is 'string' and [e] or e
		time = Math.floor(5 / errs.length)
		eep()
		showError = (e) ->
			$('body').overhang
				type: 'error'
				message: e
				duration: time
				callback: (v) -> if errs.length then showError errs.pop()
		showError errs.pop()

	getScripts = (scripts, callback) ->
		scripts = [scripts] if typeof scripts is 'string'
		scripts.forEach (script,i) ->
			$.getScript script, ->
				if (i + 1) is scripts.length then callback?()
	
	loadPage = (page) ->
		$.get page, (data) ->
			$('#content').html data
			getScripts ["/assets#{page}.js"]

	loadContent = (controllers, page) ->
		if not page	then return loadPage controllers
		else getScripts controllers, -> loadPage page
			
		
