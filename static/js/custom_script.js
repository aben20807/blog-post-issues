jQuery(document).ready(function( $ ) {
  // Get page title
  var pageTitle = $("title").text();

  // Change page title on blur
  $(window).blur(function() {
	  $("title").text("QuQ");
	});

	// Change page title back on focus
	$(window).focus(function() {
    $("title").text("OuO");

    function original() {
      $("title").text(pageTitle);
    }
	  setTimeout(original, 1000);
	});
});
