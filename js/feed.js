$(document).ready(function() {
  $('#blog').FeedEk({
    FeedUrl: 'http://diglib.org/feed',
    MaxCount: 5,
    ShowDesc: true,
    ShowPubDate: true,
    DescCharacterLimit: 100,
    TitleLinkTarget: '_blank'
  });
});
