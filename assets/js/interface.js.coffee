$ ->

	# [menu, burger] = ($(x).first() for x in ['.nav__list','.burger'])
	# [win,doc,panel] = ($(x) for x in [window,document,'.panel'])

	menuIsOpen = false
	# menuIsAnimating
	openMenu = ->
		# if not burger.is(':animated') and not menu.is(':animated')
		return if menuIsOpen
		$('#nav > ul').toggleClass('active')
		# ['burger--active','nav__list--active'][i])
		.promise().done ->
			console.log 'done animating'
			menuIsOpen = true

	$('#nav > ul > li').mouseleave ->
		q = _.toArray document.querySelectorAll(":hover")
		console.log 'move! ' + q

			# + (menuIsOpen = not menuIsOpen)
	scrollFx = ->
		ds = $(document).scrollTop()
		offs = $(window).height() / ($('.panel').size() - 1)
		# if the panel is in the viewport, reveal the content, if not, hide it.
		$('.panel').each ->
			sel = $(@).offset().top < ds + offs and 'addClass' or 'removeClass'
			$(@).find('.panel__content')[sel] 'active'

	scrolly = (e) ->
		e.preventDefault()
		target = @hash
		$('html, body').stop().animate
			scrollTop: $(target).offset().top
		, 300, 'swing', -> window.location.hash = target

	# reveal content of first panel by default
	# activate = -> $(@).find('.panel__content').addClass 'panel__content--active'
	$('.panel').first().find('.panel__content').addClass 'panel__content--active'
	# activate $('#panels').children().first()

	$('.nav__item').each ->
		c = $(@).data 'color'
		$(@).find('.nav__link').css color: c
		$('#' + $(@).data('index')).css background: c
	$('#burger').click openMenu
	# $('#nav').mouseleave openMenu
	$('#nav-zone').hover openMenu

	# $('#nav-zone').mouseleave openMenu


	$(window).on x, scrollFx for x in ['scroll','load']
	$('a[href^="#"]').click scrolly

	# sc = new SocketController()


	# window.addEventListener 'scroll', scrollFx, false
	# window.addEventListener 'load', scrollFx, false


# menu = document.querySelector('.nav__list')
	# burger = document.querySelector('.burger')
	# l = $('.scrolly')


