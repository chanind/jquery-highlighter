(function() {
  var Homepage;

  Homepage = (function() {

    Homepage.prototype.ranges = [[27, 52], [68, 93], [148, 162], [176, 189]];

    function Homepage() {
      _.bindAll(this);
      this.currentIndex = 0;
      this.markAllHighlights();
      this.nextHighlight();
      this.highlightTimer = setInterval(this.nextHighlight, 3000);
    }

    Homepage.prototype.markAllHighlights = function() {
      var range;
      return this.highlights = (function() {
        var _i, _len, _ref, _results;
        _ref = this.ranges;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          range = _ref[_i];
          _results.push($('.lead').highlighter('markHighlight', range, {
            highlightClass: 'marker'
          }));
        }
        return _results;
      }).call(this);
    };

    Homepage.prototype.nextHighlight = function() {
      var $highlight;
      $('.highlight').removeClass('highlight');
      $highlight = this.highlights[this.currentIndex];
      $highlight.addClass('highlight');
      this.currentIndex += 1;
      if (this.currentIndex >= this.ranges.length) {
        return this.currentIndex = 0;
      }
    };

    return Homepage;

  })();

  window.homepage = new Homepage();

}).call(this);
