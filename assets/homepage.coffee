---
---
class Homepage

	ranges: [
		[27, 52]
		[68, 93]
		[148, 162]
		[176, 189]
	]

	constructor: ->
		_.bindAll(@)
		@currentIndex = 0
		@markAllHighlights()
		@nextHighlight()
		@highlightTimer = setInterval @nextHighlight, 3000

	markAllHighlights: ->
		@highlights = for range in @ranges
			$('.lead').highlighter('markHighlight', range, {highlightClass: 'marker'})

	nextHighlight: ->
		$('.highlight').removeClass('highlight')
		$highlight = @highlights[@currentIndex]
		$highlight.addClass('highlight')
		@currentIndex += 1
		@currentIndex = 0 if @currentIndex >= @ranges.length

window.homepage = new Homepage()