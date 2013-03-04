$(function() {
	// all of our highlighting will be relative to this div
	var $el = $('#highlight-target');
	// save the original HTML so we can reset the demo
	var originalMarkup = $el.html();

	updateConsole = function() {
		$('#highlight-present').text($el.highlighter('selectionExists') ? 'yes' : 'no');
		$('#highlight-contained').text($el.highlighter('containsSelection') ? 'yes' : 'no');
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
			$el.highlighter('markHighlight', bounds);
			$(document).highlighter('clearSelection');
		}
	});
});