menu = document.querySelector('.nav__list')
burger = document.querySelector('.burger')
doc = $(document)
l = $('.scrolly')
panel = $('.panel')
vh = $(window).height()

openMenu = ->
	burger.classList.toggle 'burger--active'
	menu.classList.toggle 'nav__list--active'
	return

# reveal content of first panel by default
panel.eq(0).find('.panel__content').addClass 'panel__content--active'

scrollFx = ->
	ds = doc.scrollTop()
	offs = vh / 4
	# if the panel is in the viewport, reveal the content, if not, hide it.
	i = 0
	while i < panel.length
		if panel.eq(i).offset().top < ds + offs
			panel.eq(i).find('.panel__content').addClass 'panel__content--active'
		else
			panel.eq(i).find('.panel__content').removeClass 'panel__content--active'
		i++
	return

scrolly = (e) ->
	e.preventDefault()
	target = @hash
	$target = $(target)
	$('html, body').stop().animate { 'scrollTop': $target.offset().top }, 300, 'swing', ->
		window.location.hash = target
		return
	return

init = ->
	burger.addEventListener 'click', openMenu, false
	window.addEventListener 'scroll', scrollFx, false
	window.addEventListener 'load', scrollFx, false
	$('a[href^="#"]').on 'click', scrolly
	return

doc.on 'ready', init
