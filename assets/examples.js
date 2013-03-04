$(function() {
	// all of our highlighting will be relative to this div
	var $el = $('#highlight-target');
	// save the original HTML so we can reset the demo
	var originalMarkup = $el.html();

	updateConsole = function() {
		// $el.highlighter('selectionExists') tells us if anything is selected anywhere on the page
		$('#highlight-present').text($el.highlighter('selectionExists') ? 'yes' : 'no');
		// $el.highlighter('containsSelection') tells us if the selection is fully contained in the target el
		$('#highlight-contained').text($el.highlighter('containsSelection') ? 'yes' : 'no');
		// $el.highlighter('getRelativeSelectionBounds') tells us the start and end of the selection
		// this returns the start and end ignoring all the markup contained
		var bounds = $el.highlighter('getRelativeSelectionBounds');
		var startOffset = bounds[0];
		var endOffset = bounds[1];
		$('#highlight-start').text(startOffset || '--');
		$('#highlight-end').text(endOffset || '--');
		$('#reset-highlight').click(function(e) {
			e.preventDefault();
			$el.html(originalMarkup);
		});
	};

	$(document).on('mousemove', updateConsole);
	$(document).on('keypress', updateConsole);
	$(document).on('click', updateConsole);
	$(document).on('click', '#mark-highlight', function(e) {
		e.preventDefault();
		if ($el.highlighter('containsSelection')) {
			var bounds = $el.highlighter('getRelativeSelectionBounds');
			// $el.highlighter('markHighlight') takes a given bounds and highlights it with spans
			// this works well with getRelativeSelection to mark a selection using spans
			$el.highlighter('markHighlight', bounds);
			// clearSelection removes any native selections from the page
			$(document).highlighter('clearSelection');
		}
	});
});