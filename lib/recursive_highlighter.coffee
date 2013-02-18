(($, undefined) ->

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
			for node in domTree
				nodeLength = $(node).text().length
				nodeEnd = nodeLength + nodeStart
				nodeRange = [nodeStart..nodeEnd]
				if nodeStart in hlRange or nodeEnd in hlRange or hlStart in nodeRange or hlEnd in nodeRange
					nodeHlStart = Math.max(hlStart - nodeStart, 0)
					nodeHlEnd = Math.min(hlEnd - nodeStart, nodeLength)
					@highlightInNode(node, [nodeHlStart, nodeHlEnd])
				nodeStart = nodeEnd

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
			content = content[0...bounds[1]] + @getHlEndTag() + content[bounds[1]..-1]
			content = content[0...bounds[0]] + @getHlStartTag() + content[bounds[0]..-1]
			if $node[0].nodeType == 3
				$tempDiv = $('<div/>')
				$tempDiv.html(content)
				$node.replaceWith($tempDiv.contents())
			else
				$node.parent().html(content)

		getHlStartTag: -> "<#{@options.highlightTag} class='#{@options.highlightClass}'>"
		getHlEndTag: -> "</#{@options.highlightTag}>"

	$.fn.highlighter = ->
		options = arguments[-1] unless typeof arguments[-1] is 'string' or $.isArray(arguments[-1])
		options ||= {}
		highlighter = $.data(this, 'plugin_recursive_highlighter')
		highlighter ||= new RecursiveHighlighter(this, options)
		$.data(this, 'plugin_recursive_highlighter', highlighter)
		if typeof arguments[0] is "string"
			command = arguments[0]
			return highlighter[command].apply(highlighter, arguments[1..-1])

)(jQuery)


