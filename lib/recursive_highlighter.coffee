(($) ->

	class window.RecursiveHighlighter

		options:
			highlightClass: 'highlight'
			highlightTag: 'span'

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

		markHighlight: (relativeBounds) ->
			domTree = @getFlattenedDomTree()
			hlStart = relativeBounds[0]
			hlEnd = relativeBounds[1]
			hlRange = [hlStart..hlEnd]
			inserting = false
			nodeStart = 0
			highlights = []
			for node in domTree
				nodeLength = $(node).text().length
				nodeEnd = nodeLength + nodeStart
				nodeRange = [nodeStart..nodeEnd]
				if nodeStart in hlRange or nodeEnd in hlRange or hlStart in nodeRange or hlEnd in nodeRange
					nodeHlStart = Math.max(hlStart - nodeStart, 0)
					nodeHlEnd = Math.min(hlEnd - nodeStart, nodeLength)
					highlights.push @highlightInNode(node, [nodeHlStart, nodeHlEnd])
				nodeStart = nodeEnd
			$(highlights)

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

		################### PRIVATE ########################

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


		highlightInNode: (node, bounds) ->
			return if bounds[0] == bounds[1]
			$node = $(node)
			content = $node.text()
			content =
				@htmlEscape(content[0...bounds[0]]) +
				@getHlStartTag() +
				@htmlEscape(content[bounds[0]...bounds[1]]) +
				@getHlEndTag() +
				@htmlEscape(content[bounds[1]..-1])
			if $node[0].nodeType == 3
				$tempDiv = $('<div/>')
				$tempDiv.html(content)
				$nodes = $tempDiv.contents()
				$node.replaceWith($nodes)
			else
				$parent = $node.parent()
				$parent.html(content)
				$nodes = $parent.contents()
			highlights = $nodes.filter (i, node) -> node.nodeType isnt 3
			highlights[0]

		getHlStartTag: -> "<#{@options.highlightTag} class='#{@options.highlightClass}'>"
		getHlEndTag: -> "</#{@options.highlightTag}>"

		htmlEscape: (str) ->
			(""+str)
				.replace(/&/g,"&amp;")
				.replace(/</g,"&lt;")
				.replace(/>/g,"&gt;")
				.replace(/"/g,"&quot;")
				.replace(/'/g,"&#x27;")
				.replace(/\//g,"&#x2F;")

	findOrCreateHighlighter = (elm, options, forceRecreate = false) ->
		highlighter = $.data(this, 'plugin_recursive_highlighter')
		if forceRecreate or !highlighter
			highlighter = new RecursiveHighlighter(this, options)
		$.data(this, 'plugin_recursive_highlighter', highlighter)
		highlighter

	$.fn.highlighter = ->
		args = Array.prototype.slice.apply(arguments)
		options = args[-1] unless typeof args[-1] is 'string' or $.isArray(args[-1])
		options ||= {}
		if typeof args[0] is "string"
			highlighter = findOrCreateHighlighter(this, options)
			command = args[0]
			return highlighter[command].apply(highlighter, args[1..-1])
		else
			findOrCreateHighlighter(this, options, true)


)(jQuery)


