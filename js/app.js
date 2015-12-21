$(window).load(function(){


});

$(document).ready(function(){

  $('.sticky').sticky({topSpacing: 0});

  // $('.status').fadeOut();
  // $('.preloader').delay(350).fadeOut('slow');

  wow = new WOW(
    {
      animateClass: 'animated',
      offset: 100,
      mobile: true
    }
  );

  wow.init();

  $('.services-box').css('cursor', 'pointer');
  $('.services-box').click(function(){
    window.location = $(this).find('a').attr('href');
    return false;
  });
});
