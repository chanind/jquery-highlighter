should = chai.should()
mocha.setup('bdd')

fixtures =
	bare: "this is some text to highlight"
	tags: "this is some <b>text</b> to highlight"
	nested: "this <span><b>is <br />some text <i>to</i><b></span> highlight"

loadFixture: (fixture) -> $('#fixture').html(fixture)

describe 'RecursiveHighlighter', ->
	describe '#markHighlight', ->
		it "should mark the selection specified by the range using a span when there is just bare text", ->
			loadFixture(fixtures.bare)
			$('#fixture').highlighter "markHighlight", [4, 25]
			$('#fixture').html.should.equal 'this<span class="highlight"> is some text to high</span>light'


