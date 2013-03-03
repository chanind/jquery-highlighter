---
---
class Homepage

	ranges: [
		[27, 52]
		[68, 97]
		[152, 166]
		[180, 193]
	]

	constructor: ->
		_.bindAll(@)
		@currentRangeIndex = 0
		@nextHighlight()
		@highlightTimer = setInterval @nextHighlight, 3000

	nextHighlight: ->
		range = @ranges[@currentRangeIndex]
		$('.highlight').removeClass('highlight')
		$lastHighlight = $('.lead').highlighter('markHighlight', range, {highlightClass: 'marker'})
		setTimeout ->
			$lastHighlight.addClass('highlight')
		, 500
		@currentRangeIndex += 1
		@currentRangeIndex = 0 if @currentRangeIndex >= @ranges.length

window.homepage = new Homepage()