otherIcons = ['bolt','exclamation-triangle','map-marker','building-o','support','home']
colors = ['#8840a7','#f25f5c','#ffe066','#3cd088','#70c1b3']

icons = ['building','camera-retro','bullhorn','map-marker','bolt']
titles = ['113W15', 'Door Cam', 'Chat','Info','Vegge']
texts = [
		'Look at my monkey hoof.'
		'I have a huge vageen.'
  	'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ea molestias ducimus, eos asperiores, ab officia sint nostrum quia, corporis officiis id praesentium expedita numquam ad non error optio est in.'
		'Paleo authentic mlkshk taxidermy, vinyl meditation lomo drinking vinegar sartorial raw denim Thundercats bitters selvage listicle. Keffiyeh Williamsburg gastropub McSweeney\'s.'
  	'Beard sriracha kitsch literally, taxidermy normcore aesthetic wayfarers salvia keffiyeh farm-to-table sartorial gluten-free mlkshk. Selvage normcore 3 wolf o, umami Kickstarter artisan meggings cardigan drinking vinegar bicycle rights.'
]
module.exports = [0..4].map (i) ->
	color: colors[i]
	title: titles[i]
	text: texts[i]
	icon: icons[i]
