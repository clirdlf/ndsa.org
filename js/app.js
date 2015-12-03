$(window).load(function(){
  $('.status').fadeOut();
  $('.preloader').delay(350).fadeOut('slow');
});

$(document).ready(function(){

  wow = new WOW(
    {
      animateClass: 'animated',
      offset: 100,
      mobile: true
    }
  );
  wow.init();
});
