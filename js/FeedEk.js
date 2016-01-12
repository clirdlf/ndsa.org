/*
* FeedEk jQuery RSS/ATOM Feed Plugin v3.0 with YQL API
* http://jquery-plugins.net/FeedEk/FeedEk.html  https://github.com/enginkizil/FeedEk
* Author : Engin KIZIL http://www.enginkizil.com
*/
// https://query.yahooapis.com/v1/public/yql?q=SELECT%20entry%20FROM%20feednormalizer%20WHERE%20output%3D%22atom_1.0%22%20AND%20url%20%3D%22http%3A%2F%2Fmix.chimpfeedr.com%2F7f8d0-NDSA%22%20LIMIT%205&format=json&diagnostics=false&callback=
// https://query.yahooapis.com/v1/public/yql?q=SELECT%20results.entry%20FROM%20feednormalizer%20WHERE%20output%3D%22atom_1.0%22%20AND%20url%20%3D%22http%3A%2F%2Fmix.chimpfeedr.com%2F7f8d0-NDSA%22%20LIMIT%205&format=json&diagnostics=false&callback=
(function ($) {
    $.fn.FeedEk = function (opt) {
        var def = $.extend({
            MaxCount: 5,
            ShowDesc: true,
            ShowPubDate: true,
            DescCharacterLimit: 0,
            TitleLinkTarget: "_blank",
            DateFormat: "",
            DateFormatLang:"en"
        }, opt);

        var id = $(this).attr("id"), i, s = "", dt;
        $("#" + id).empty();

        if (def.FeedUrl === undefined) return;

        $("#" + id).append('<img class="img-responsive center-block" width="40px" src="images/loader.gif" />');

        var YQLstr = 'SELECT entry FROM feednormalizer WHERE output="atom_1.0" AND url ="' + def.FeedUrl + '" LIMIT ' + def.MaxCount;
        //console.log("https://query.yahooapis.com/v1/public/yql?q=" + encodeURIComponent(YQLstr) + "&format=json&diagnostics=false&callback=?");
        $.ajax({
            url: "https://query.yahooapis.com/v1/public/yql?q=" + encodeURIComponent(YQLstr) + "&format=json&diagnostics=false&callback=?",
            dataType: "json",
            success: function (data) {
                $("#" + id).empty();

                if (!(data.query.results.feed instanceof Array)) {
                    data.query.results.feed = [data.query.results.feed];
                }

                // add link to site home
                s += '<li><h1 class="summary"><a href="http://blogs.loc.gov/digitalpreservation/category/ndsa-2/">See More</a></div></li>';

                $.each(data.query.results.feed, function (e, itm) {
                    s += '<li><div class="itemTitle"><a href="' + itm.entry.link.href + '" target="' + def.TitleLinkTarget + '" >' + itm.entry.title.content + '</a></div>';

                    if (def.ShowPubDate){
                        dt = new Date(itm.entry.updated);
                        s += '<div class="itemDate">';
                        if ($.trim(def.DateFormat).length > 0) {
                            try {
                                moment.lang(def.DateFormatLang);
                                s += moment(dt).format(def.DateFormat);
                            }
                            catch (ex){ s += dt.toLocaleDateString(); }
                        }
                        else {
                            s += dt.toLocaleDateString();
                        }
                        s += '</div>';
                    }
                    if (def.ShowDesc) {
                        s += '<div class="itemContent">';
                        // console.log(itm.entry);
                         if (def.DescCharacterLimit > 0 && itm.entry.summary.content.length > def.DescCharacterLimit) {
                            s += itm.entry.summary.content.substring(0, def.DescCharacterLimit) + '...';
                        }
                        else {
                            s += itm.entry.summary.content;
                         }
                         s += '</div>';
                    }
                });
                $("#" + id).append('<ul class="feedEkList">' + s + '</ul>');
            }
        });
    };
})(jQuery);
