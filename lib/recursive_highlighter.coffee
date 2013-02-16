class window.RecursiveHighlighter

	options: {}

	constructor: (target, options = {}) ->
		@$el = $(target)
		@options = $.extend(@options, options)

	containsSelection: ->
		return false unless @selectionExists()
		range = @getRange()
		$start = $(range.startContainer)
		$end = $(range.endContainer)
		containsStart = $start.parents().toArray().indexOf(@$el[0]) != -1
		containsEnd = $end.parents().toArray().indexOf(@$el[0]) != -1
		return containsStart and containsEnd

	selectionExists: -> if @getRange() then true else false

	getRange: ->
	    if window.getSelection
	      selection = window.getSelection()
	      if selection.rangeCount > 0 then selection.getRangeAt(0) else false
	    else if document.selection
	      document.selection.createRange()


	getRelativeSelectionBounds: ->
		return false unless @containsSelection()
		range = @getRange()
		$end = $(range.endContainer)
		startOffset = @getNumCharactersUntil(range.startContainer) + range.startOffset
		endOffset = @getNumCharactersUntil(range.endContainer) + range.endOffset
		return [startOffset, endOffset]

	getNumCharactersUntil: (elm) ->
		[numChars, success] = @recurseGetNumCharsUntil(@$el, elm)
		return success && numChars

	getFlattenedDomTree: ->
		return @recurseGetFlattenedDomTree([], @$el)

	recurseGetFlattenedDomTree: (previousFlattenedTree, currentNode) ->
		flattenedTree = previousFlattenedTree.slice()
		$currentNode = $(currentNode)
		children = $currentNode.contents()
		if children.length > 0
			for child in children.toArray()
				flattenedTree = @recurseGetFlattenedDomTree(flattenedTree, child)
		else
			flattenedTree.push($currentNode[0])
		flattenedTree


	recurseGetNumCharsUntil: (root, elm) ->
		numChars = 0
		$elm = $(elm)
		$root = $(root)

		if $root[0] == $elm[0]
			return [0, true]
		else
			children = $root.contents()
			if children.length > 0
				for child in children.toArray()
					[charOffset, found] = @recurseGetNumCharsUntil(child, elm)
					numChars += charOffset
					return [numChars, true] if found
			else
				return [$root.text().length, false]
		return [numChars, false]


	markHighlight: (relativeBounds) ->







SelectionUtils =
  hasSelection: ->
    if @getRange() then true else false
  getRange: ->
