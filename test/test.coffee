$ ->
	highlighter = new RecursiveHighlighter('#highlight-target')

	updateConsole = ->
		$('#highlight-present').text(if highlighter.selectionExists() then 'yes' else 'no')
		$('#highlight-contained').text(if highlighter.containsSelection() then 'yes' else 'no')
		[startOffset, endOffset] = highlighter.getRelativeSelectionBounds()
		$('#highlight-start').text(startOffset)
		$('#highlight-end').text(endOffset)

	$(document).on 'mousemove', updateConsole
	$(document).on 'keypress', updateConsole
	$(document).on 'click', updateConsole
	$(document).on 'click', '#mark-highlight', ->
		if highlighter.containsSelection()
			highlighter.markHighlight(highlighter.getRelativeSelectionBounds())