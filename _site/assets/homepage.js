(function() {
  var Homepage;

  Homepage = (function() {

    Homepage.prototype.ranges = [[27, 52], [68, 97], [152, 166], [180, 193]];

    function Homepage() {
      _.bindAll(this);
      this.currentRangeIndex = 0;
      this.nextHighlight();
      this.highlightTimer = setInterval(this.nextHighlight, 3000);
    }

    Homepage.prototype.nextHighlight = function() {
      var $lastHighlight, range;
      range = this.ranges[this.currentRangeIndex];
      $('.highlight').removeClass('highlight');
      $lastHighlight = $('.lead').highlighter('markHighlight', range, {
        highlightClass: 'marker'
      });
      setTimeout(function() {
        return $lastHighlight.addClass('highlight');
      }, 500);
      this.currentRangeIndex += 1;
      if (this.currentRangeIndex >= this.ranges.length) {
        return this.currentRangeIndex = 0;
      }
    };

    return Homepage;

  })();

  window.homepage = new Homepage();

}).call(this);
