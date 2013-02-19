mocha.setup('bdd')
should = chai.should()

fixtures =
	bare: "this is some text to highlight"
	tags: "this is some <b>text</b> to highlight"
	nested: "this <span><b>is some text to</b></span> highlight"

loadFixture = (fixture) -> $('#fixture').html(fixture)

describe 'Highlighter', ->
	describe '#markHighlight', ->

		it "should mark the selection specified by the range using a span when there is a contained tag", ->
			loadFixture(fixtures.tags)
			$('#fixture').highlighter "markHighlight", [4, 25]
			expected =	"""
						this
						<span class="highlight"> is some </span>
						<b><span class="highlight">text</span></b>
						<span class="highlight"> to high</span>light
						""".replace /\n/g, ''
			$('#fixture').html().should.equal expected

		it "should mark the selection specified by the range using a span when there is only raw text", ->
			loadFixture(fixtures.bare)
			$('#fixture').highlighter "markHighlight", [4, 25]
			$('#fixture').html().should.equal 'this<span class="highlight"> is some text to high</span>light'

		it "should mark the selection specified by the range using a span when there are nested tags", ->
			loadFixture(fixtures.nested)
			$('#fixture').highlighter "markHighlight", [4, 25]
			expected =	"""
						this
						<span class="highlight"> </span>
						<span><b>
						<span class="highlight">is some text to</span>
						</b></span>
						<span class="highlight"> high</span>light
						""".replace /\n/g, ''
			$('#fixture').html().should.equal expected


