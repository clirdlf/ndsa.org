$(document).ready(function() {
  $('#blog').FeedEk({
    // FeedUrl: 'https://www.diglib.org/topics/ndsa/feed/',
    // FeedUrl: 'http://mix.chimpfeedr.com/7f8d0-NDSA', // mix the feed for LoC & diglib
    FeedUrl: 'https://www.diglib.org/topics/ndsa/feed', // mix the feed for LoC & diglib
    MaxCount: 5,
    ShowDesc: true,
    ShowPubDate: true,
    DescCharacterLimit: 100,
    TitleLinkTarget: '_blank'
  });
});
