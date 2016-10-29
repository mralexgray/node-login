
menuIsOpen = false
animating = false
`window['toggleMenu'] = undefined;`

toggleMenu = (open) ->

	return if menuIsOpen and ['#nav-zone','.burger'].some (x) -> $(x).is ':hover'

	console.log "toggling ?:#{open?} > #{open}. menuIsOpen: #{menuIsOpen}"
	animating = true
	$('#nav-zone').unbind 'hover'
	$('#nav > ul, .burger').toggleClass('active').promise().done ->
		menuIsOpen =! menuIsOpen
		animating = false
		console.log "done animating. menuIsOpen: #{menuIsOpen}"
		$('#nav-zone').hover toggleMenu

$ ->
	list = $('<ul>')
	sct = JSON.parse $('#sections').val()
	console.log typeof sct
	for x,i in sct
		li = $('<li>')
		a = $("<a href='##{i}' class='c-#{x.color}'>").css color:x.color
		a.prepend("<i class='fa fa-#{x.icon}'>")
		li.append a
		li.appendTo list
		sx = $("<section id='#{i}' class='panel'>").css background:x.color
		art = $("""
			<article class='wrapper'>
				<div class='content'>
					<h1 class='headline'>
						<i class='fa fa-#{x.icon}' />&nbsp;#{x.title}
					</h1>
					<div class='block'>#{x.text or ''}</div>
				</div>
			</article>
		""")
		$('#panels').append sx.append(art)

	$('#nav').append list

		# $('#nav > ul > li').each ->
	# 	[c,i] = ($(@).data x for x in ['color','index'])
	# 	$(@).find('a').css color: c
	# 	$('#' + i).css background: c


	scrolly = (e) ->
		e.preventDefault()
		target = @hash
		$('html, body').stop().animate
			scrollTop: $(target).offset().top
		, 300, 'swing', -> window.location.hash = target

	scrollFx = ->
		ds = $(document).scrollTop()
		offs = $(window).height() / ($('.panel').size() - 1)
		# if the panel is in the viewport, reveal the content, if not, hide it.
		$('.panel').each ->
			# find('.content').toggleClass 'active'
		# each ->
			sel = $(@).offset().top < ds + offs and 'addClass' or 'removeClass'
			x = $(@).find('.content')
			x[sel] z for z in ['active'] # ,'dasharray']

			# $(@).find('.content').toggleClass 'active'

	$('.panel').first().find('.content').addClass 'active'

	# $('#nav > ul > li').each ->
	# 	[c,i] = ($(@).data x for x in ['color','index'])
	# 	$(@).find('a').css color: c
	# 	$('#' + i).css background: c

	$('.burger').click -> console.log "#{not menuIsOpen}"; toggleMenu not menuIsOpen

	$('#nav-zone').hover -> toggleMenu not menuIsOpen
	$('#nav > ul').mouseleave -> toggleMenu false

	$(window).on x, scrollFx for x in ['scroll','load']

	$('a[href^="#"]').click scrolly

	$("#panels > section[id='2']").find('.content').append $('#login')

	# activate $('#panels').children().first()
	# reveal content of first panel by default
	# activate = -> $(@).find('.panel__content').addClass 'panel__content--active'
	# $('#nav').mouseleave openMenu
	# $('#nav-zone').mouseleave openMenu




	# if not burger.is(':animated') and not menu.is(':animated')

	# ['burger--active','nav__list--active'][i])menuIsOpen

	# $('#nav > ul > li').mouseleave ->
	# 	q = _.toArray document.querySelectorAll(":hover")
	# 	console.log 'move! ' + q


	# sc = new SocketController()


	# window.addEventListener 'scroll', scrollFx, false
	# window.addEventListener 'load', scrollFx, false


# menu = document.querySelector('.nav__list')
	# burger = document.querySelector('.burger')
	# l = $('.scrolly')




	# [menu, burger] = ($(x).first() for x in ['.nav__list','.burger'])
	# [win,doc,panel] = ($(x) for x in [window,document,'.panel'])

			# + (menuIsOpen = not menuIsOpen)
