(function(self){
  function initBlocksLayout () {
    $(".block").each(function(i, e) {
      $(e).addClass("skew-" + _.random(0, 4));
      $(e).addClass("bkg-" + _.random(0, 4));
    });
  }



  $(document).ready(function() {
    initBlocksLayout();
  });
})(this);
