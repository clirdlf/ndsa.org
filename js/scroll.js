$(document).ready(function() {
  $('a').bind('click', function(event) {
    var $anchor = $(this);
    $('html, body').stop().animate({
      scrollTop: $($anchor.attr('href')).offset().top - 78
    }, 1500, 'easeInOutExpo');
    event.preventDefault();
  });
});
