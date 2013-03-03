(function() {
  var Homepage;

  Homepage = (function() {

    Homepage.prototype.ranges = [[3, 40], [37, 100], [80, 140]];

    function Homepage() {
      _.bindAll(this);
      alert('here');
    }

    return Homepage;

  })();

  window.homepage = new Homepage();

}).call(this);
