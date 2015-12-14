$(document).ready(function() {
  $('#blog').FeedEk({
    FeedUrl: 'http://blogs.loc.gov/digitalpreservation/category/ndsa-2/feed/',
    MaxCount: 5,
    ShowDesc: true,
    ShowPubDate: true,
    DescCharacterLimit: 100,
    TitleLinkTarget: '_blank'
  });
});
