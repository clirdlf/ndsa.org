---
layout: page
title: News from the NDSA
permalink: /news/
redirect_from: /blog/
---

{% for post in site.posts %}
<article class="tile" itemscope itemtype="http://schema.org/Article">
  <h2 class="post-title" itemprop="name"><a href="{{ site.url }}{{ post.url }}">{{ post.title }}</a></h2>

  {% if post.date %}<p class="entry-date date published"><time datetime="{{ post.date | date: "%Y-%m-%d" }}" itemprop="datePublished">{{ post.date | date: "%B %d, %Y" }}</time></p>{% endif %}
  <p class="post-excerpt" itemprop="description">{{ post.excerpt | strip_html | truncate: 160 }}</p>
</article><!-- /.tile -->
{% endfor %}

 <p class="rss-subscribe">subscribe <a href="{{ "/feed.xml" | prepend: site.baseurl }}">via RSS <i class="fa fa-rss"></i></a></p>
