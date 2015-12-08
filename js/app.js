$(window).load(function(){
  $('.sticky').sticky({topSpacing: 0});

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

  $('#blog').FeedEk({
    FeedUrl: 'http://diglib.org/feed',
    MaxCount: 5,
    ShowDesc: true,
    ShowPubDate: true,
    DescCharacterLimit: 100,
    TitleLinkTarget: '_blank'
  });


});
