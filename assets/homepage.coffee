---
---
class Homepage

	ranges: [
		[3, 40]
		[37, 100]
		[80, 140]
	]

	constructor: ->
		_.bindAll(@)
		alert('here')

window.homepage = new Homepage()