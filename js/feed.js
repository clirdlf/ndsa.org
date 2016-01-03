$(document).ready(function() {
  $('#blog').FeedEk({
    // FeedUrl: 'http://blogs.loc.gov/digitalpreservation/category/ndsa-2/feed/',
    FeedUrl: 'http://mix.chimpfeedr.com/7f8d0-NDSA', // mix the feed for LoC & diglib
    MaxCount: 5,
    ShowDesc: true,
    ShowPubDate: true,
    DescCharacterLimit: 100,
    TitleLinkTarget: '_blank'
  });
});
