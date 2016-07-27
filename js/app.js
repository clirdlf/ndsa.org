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

  /* Simple spam protection for email addresses using jQuery.
   * Well, the protection isn’t jQuery-based, but you get the idea.
   * This snippet allows you to slightly ‘obfuscate’ email addresses to make it harder for spambots to harvest them, while still offering a readable address to your visitors.
   * E.g.
   * <a href="mailto:foo(at)example(dot)com">foo at example dot com</a>
   * →
   * <a href="mailto:foo@example.com">foo@example.com</a>
   */
  $('a[href^="mailto:"]').each(function() {
    this.href = this.href.replace('(at)', '@').replace(/\(dot\)/g, '.');
    this.innerHTML = this.href.replace('mailto:', '');
  });
});
