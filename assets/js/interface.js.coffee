$ ->
	
	[menu, burger] = ($(x).first() for x in ['.nav__list','.burger'])
	[doc,panel] = ($(x) for x in [document,'.panel'])

	openMenu = ->
		for x,i in [burger,menu]
			x.toggleClass ['burger--active','nav__list--active'][i] 
	scrollFx = ->
		ds = doc.scrollTop()
		offs = $(window).height() / ($('.panel').size() - 1)
		# if the panel is in the viewport, reveal the content, if not, hide it.
		panel.each ->
			sel = $(@).offset().top < ds + offs and 'addClass' or 'removeClass'
			$(@).find('.panel__content')[sel] 'panel__content--active'

	scrolly = (e) ->
		e.preventDefault()
		target = @hash
		$('html, body').stop().animate
			'scrollTop': $(target).offset().top
		, 300, 'swing', -> window.location.hash = target

	# reveal content of first panel by default
	panel.first().find('.panel__content').addClass 'panel__content--active'

	$('.nav__item').each ->
		c = $(@).data 'color'
		$(@).find('.nav__link').css color: c
		$('#' + $(@).data('index')).css background: c
	$(burger).click openMenu
	$(window).on 'scroll', scrollFx
	$(window).on 'load', scrollFx
	$('a[href^="#"]').click scrolly
	
	# sc = new SocketController()


	# window.addEventListener 'scroll', scrollFx, false
	# window.addEventListener 'load', scrollFx, false


# menu = document.querySelector('.nav__list')
	# burger = document.querySelector('.burger')
	# l = $('.scrolly')
	
	
