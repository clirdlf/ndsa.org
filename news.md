---
layout: page
title: News from the NDSA
permalink: /news/
redirect_from: /blog/
redirect_from: /news2/
---
<style>
.articles {
  display: grid;
  grid-column-gap:15px;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
}
article p {
  width:90%;
}
</style>

 <p class="rss-subscribe">Subscribe <a href="{{ "/feed.xml" | prepend: site.baseurl }}">via RSS <i class="fa fa-rss"></i></a></p>
<div class="articles">
{% for post in site.posts %}
<article  itemscope itemtype="http://schema.org/Article">
  <h2 class="post-title" itemprop="name"><a href="{{ site.url }}{{ post.url }}">{{ post.title }}</a></h2>

  {% if post.date %}<p class="entry-date date published"><time datetime="{{ post.date | date: "%Y-%m-%d" }}" itemprop="datePublished">{{ post.date | date: "%B %d, %Y" }}</time></p>{% endif %}
  <p class="post-excerpt" itemprop="description">{{ post.excerpt | strip_html | truncate: 500 }}</p>
</article>
{% endfor %}
</div>