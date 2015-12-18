$(document).ready(function() {

  var offset = 200;
  var duration = 500;

  $('a').bind('click', function(event) {
    var $anchor = $(this);
    $('html, body').stop().animate({
      scrollTop: $($anchor.attr('href')).offset().top - 78
    }, 1500, 'easeInOutExpo');
    event.preventDefault();
  });

  $(window).scroll(function() {
    if ($(this).scrollTop() > offset) {
      console.log('yep');
      $('.scroll-to-top').fadeIn(duration);
    } else {
      console.log('nope');
      $('.scroll-to-top').fadeOut(duration);
    }
  });

  $('.scroll-to-top').click(function(event) {
    event.preventDefault();
    $('html, body').animate({
      scrollTop: 0
    }, duration);
    return false;
  });

});
