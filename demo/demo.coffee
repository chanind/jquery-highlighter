$ ->
	$el = $('#highlight-target')

	updateConsole = ->
		$('#highlight-present').text(if $el.highlighter('selectionExists') then 'yes' else 'no')
		$('#highlight-contained').text(if $el.highlighter('containsSelection') then 'yes' else 'no')
		[startOffset, endOffset] = $el.highlighter('getRelativeSelectionBounds')
		$('#highlight-start').text(startOffset)
		$('#highlight-end').text(endOffset)

	$(document).on 'mousemove', updateConsole
	$(document).on 'keypress', updateConsole
	$(document).on 'click', updateConsole
	$(document).on 'click', '#mark-highlight', ->
		if $el.highlighter('containsSelection')
			bounds = $el.highlighter('getRelativeSelectionBounds')
			window.lastHighlight = $el.highlighter('markHighlight', bounds)