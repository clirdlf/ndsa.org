---
layout: page
title: News from the NDSA
permalink: /news2/
---
<style>
article{
  width:25em;
  height:25em;
  float:left;
  margin:1em;
}
article h2 {
  font-size: 1.5em;
}
article p {
  font-size: 1em;
}
</style>

 <p class="rss-subscribe">Subscribe <a href="{{ "/feed.xml" | prepend: site.baseurl }}">via RSS <i class="fa fa-rss"></i></a></p>

{% for post in site.posts %}
<article class="tile" itemscope itemtype="http://schema.org/Article">
  <h2 class="post-title" itemprop="name"><a href="{{ site.url }}{{ post.url }}">{{ post.title }}</a></h2>

  {% if post.date %}<p class="entry-date date published"><time datetime="{{ post.date | date: "%Y-%m-%d" }}" itemprop="datePublished">{{ post.date | date: "%B %d, %Y" }}</time></p>{% endif %}
  <p class="post-excerpt" itemprop="description">{{ post.excerpt | strip_html | truncate: 500 }}</p>
</article>
{% endfor %}